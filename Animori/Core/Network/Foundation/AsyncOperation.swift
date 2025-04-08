//
//  AsyncOperation.swift
//  Animori
//
//  Created by 이빈 on 4/8/25.
//

import Foundation

// MARK: - AsyncOperation
final class AsyncOperation: Operation {
    private let task: (@escaping () -> Void) -> Void
    private var _isExecuting: Bool = false
    private var _isFinished: Bool = false
    
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
