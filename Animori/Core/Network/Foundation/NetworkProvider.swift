//
//  NetworkProvider.swift
//  Animori
//
//  Created by 이빈 on 3/30/25.
//

import Foundation
import RxSwift

// MARK: - NetworkProvider
struct NetworkProvider<E: EndPoint>: Sendable {
    private let queue: OperationQueue
    private let session: URLSession
    private let rateLimiter: RateLimiter

    init(maxConcurrentRequests: Int = 1,
         timeoutInterval: TimeInterval = 30,
         rateLimiter: RateLimiter) {

        queue = OperationQueue()
        queue.maxConcurrentOperationCount = maxConcurrentRequests

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        session = URLSession(configuration: configuration)

        self.rateLimiter = rateLimiter
        print("[NetworkProvider] 초기화 완료.")
    }

    func request<T: Decodable>(_ endPoint: E) -> Single<T> {
        return Single.create { single in
            let operation = AsyncOperation { taskCompletion in
                Task {
                    defer { taskCompletion() }

                    print("[NetworkProvider] 요청 전 RateLimiter.acquire() 호출 - Endpoint: \(endPoint)")

                    await withTaskCancellationHandler {
                        await self.rateLimiter.acquire()
                    } onCancel: {
                        print("[NetworkProvider] RateLimiter.acquire 취소됨")
                        taskCompletion()
                        return
                    }

                    print("[NetworkProvider] RateLimiter.acquire() 완료. 요청 시작 - Endpoint: \(endPoint)")

                    do {
                        let request = try endPoint.asURLRequest()
                        print("[NetworkProvider] URLRequest 생성: \(request)")

                        let (data, response): (Data, URLResponse) = try await withTaskCancellationHandler {
                            try await self.session.data(for: request)
                        } onCancel: {
                            print("[NetworkProvider] URLSession task 취소됨 - Endpoint: \(endPoint)")
                            taskCompletion()
                            return
                        }

                        guard let httpResponse = response as? HTTPURLResponse,
                              (200..<300).contains(httpResponse.statusCode) else {
                            single(.failure(endPoint.error((response as? HTTPURLResponse)?.statusCode, data: data)))
                            return
                        }

                        let decoded = try endPoint.decoder.decode(T.self, from: data)
                        single(.success(decoded))
                        print("[NetworkProvider] 성공적으로 디코딩 완료 - Endpoint: \(endPoint)")

                    } catch {
                        if Task.isCancelled {
                            print("[NetworkProvider] 요청 취소됨 - Endpoint: \(endPoint)")
                        } else {
                            print("[NetworkProvider] 요청 실패 - \(endPoint), 에러: \(error)")
                        }
                        single(.failure(error))
                    }
                }
            }

            self.queue.addOperation(operation)

            return Disposables.create {
                print("[NetworkProvider] Disposable.create 호출됨 - Endpoint: \(endPoint)")
                operation.cancel()
            }
        }
    }
}
