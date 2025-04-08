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
    
    init(maxConcurrentRequests: Int = 2,
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
                    // 네트워크 요청 시작 전에 RateLimiter를 통해 토큰 획득
                    print("[NetworkProvider] 요청 전 RateLimiter.acquire() 호출 - Endpoint: \(endPoint)")
                    await self.rateLimiter.acquire()
                    print("[NetworkProvider] RateLimiter.acquire() 완료. 요청 시작 - Endpoint: \(endPoint)")
                    
                    do {
                        let request = try endPoint.asURLRequest()
                        print("[NetworkProvider] URLRequest 생성: \(request)")
                        let (data, response) = try await self.session.data(for: request)
                        
                        guard let httpResponse = response as? HTTPURLResponse,
                              (200..<300).contains(httpResponse.statusCode) else {
                            print("[NetworkProvider] HTTP 에러 응답: \(response)")
                            single(.failure(endPoint.error((response as? HTTPURLResponse)?.statusCode, data: data)))
                            taskCompletion()
                            return
                        }
                        
                        let decodedData = try endPoint.decoder.decode(T.self, from: data)
                        print("[NetworkProvider] 성공적으로 디코딩 완료 - Endpoint: \(endPoint)")
                        single(.success(decodedData))
                    } catch {
                        print("[NetworkProvider] 요청 실패 - Endpoint: \(endPoint), 에러: \(error)")
                        single(.failure(error))
                    }
                    taskCompletion()
                }
            }
            self.queue.addOperation(operation)
            return Disposables.create { operation.cancel() }
        }
    }
}
