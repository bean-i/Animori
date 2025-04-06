//
//  NetworkProvider.swift
//  Animori
//
//  Created by 이빈 on 3/30/25.
//

import Foundation
import RxSwift

struct NetworkProvider<E: EndPoint>: Sendable {
    private let queue: OperationQueue
    private let session: URLSession
    
    init(maxConcurrentRequests: Int = 3, timeoutInterval: TimeInterval = 30) {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = maxConcurrentRequests
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval // 30초 타임아웃
        session = URLSession(configuration: configuration)
    }
    
    func request<T: Decodable>(_ endPoint: E) -> Single<T> {
        return Single.create { single in
            let operation = AsyncOperation { taskCompletion in
                Task {
                    do {
                        let request = try endPoint.asURLRequest()
                        let (data, response) = try await session.data(for: request)
                        guard let httpResponse = response as? HTTPURLResponse,
                              (200..<300).contains(httpResponse.statusCode) else {
                            single(.failure(endPoint.error((response as? HTTPURLResponse)?.statusCode, data: data)))
                            taskCompletion()
                            return
                        }
                        
                        let decodedData = try endPoint.decoder.decode(T.self, from: data)
                        single(.success(decodedData))
                        taskCompletion()
                    } catch {
                        single(.failure(error))
                        taskCompletion()
                    }
                }
            }
            self.queue.addOperation(operation)
            return Disposables.create { operation.cancel() }
        }
        .delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}

class AsyncOperation: Operation {
    private let task: (@escaping () -> Void) -> Void
    private var _isExecuting = false
    private var _isFinished = false
    
    init(task: @escaping (@escaping () -> Void) -> Void) {
        self.task = task
    }
    
    override var isExecuting: Bool {
        get { _isExecuting }
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isFinished: Bool {
        get { _isFinished }
        set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func start() {
        if isCancelled { return }
        isExecuting = true
        task { [weak self] in
            self?.finish()
        }
    }
    
    func finish() {
        isExecuting = false
        isFinished = true
    }
}
