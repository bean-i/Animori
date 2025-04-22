//
//  AsyncOperation.swift
//  Animori
//
//  Created by 이빈 on 4/8/25.
//

import Foundation

// MARK: - AsyncOperation
class AsyncOperation: Operation {
    
    // MARK: - Operation State Enum
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String { "is" + rawValue.capitalized }
    }
    
    // MARK: - Thread-safe State Management
    private let stateQueue = DispatchQueue(label: "com.animori.asyncoperation.state", attributes: .concurrent)
    private var _state: State = .ready
    
    private var state: State {
        get {
            return stateQueue.sync { _state }
        }
        set {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
            stateQueue.sync(flags: .barrier) {
                _state = newValue
            }
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: newValue.keyPath)
        }
    }
    
    // MARK: - Overrides
    override var isAsynchronous: Bool { true }
    override var isReady: Bool { super.isReady && state == .ready }
    override var isExecuting: Bool { state == .executing }
    override var isFinished: Bool { state == .finished }
    
    private var internalTask: Task<Void, Never>?
    
    // MARK: - Task Logic
    private let operationTask: (@escaping () -> Void) -> Void
    
    init(task: @escaping (@escaping () -> Void) -> Void) {
        self.operationTask = task
        super.init()
    }

    override func start() {
        if isCancelled {
//            print("[AsyncOperation] start 전에 이미 취소됨 → finish()")
            finish()
            return
        }
        
        state = .executing
        
        internalTask = Task {
            if Task.isCancelled {
//                print("[AsyncOperation] Task 시작 전 취소됨")
                finish()
                return
            }

            await withCheckedContinuation { continuation in
                self.operationTask {
                    continuation.resume()
                }
            }

            finish()
        }
    }
    
    override func cancel() {
        super.cancel()
//        print("[AsyncOperation] cancel() 호출됨")
        internalTask?.cancel()
        finish()
    }

    func finish() {
        if !isFinished {
            state = .finished
        }
    }
}
