//
//  RateLimiter.swift
//  Animori
//
//  Created by 이빈 on 4/8/25.
//

import Foundation
// MARK: - 전역 공유 RateLimiter
let GlobalRateLimiter = RateLimiter(maxRequests: 1, interval: 0.7)

// MARK: - Actor 기반 RateLimiter
actor RateLimiter {
    private let maxRequests: Int
    private var available: Int
    private let interval: TimeInterval
    private var lastRefill: Date

    init(maxRequests: Int, interval: TimeInterval) {
        self.maxRequests = maxRequests
        self.available = maxRequests
        self.interval = interval
        self.lastRefill = Date()
        print("[RateLimiter] 초기화 - maxRequests: \(maxRequests), interval: \(interval)")
    }
    
    func acquire() async {
        while true {
            refillIfNeeded()
            if available > 0 {
                available -= 1
                print("[RateLimiter] 토큰 소비. 남은 토큰: \(available)")
                return
            } else {
                print("[RateLimiter] 토큰 부족. 대기 중...")
            }
            // 토큰이 없으면 interval만큼 대기 후 다시 시도
            do {
                try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            } catch {
                print("[RateLimiter] Task.sleep 에러: \(error)")
                return
            }
        }
    }
    
    private func refillIfNeeded() {
        let now = Date()
        let elapsed = now.timeIntervalSince(lastRefill)
        if elapsed >= interval {
            available = maxRequests
            lastRefill = now
            print("[RateLimiter] 토큰 재충전. available: \(available) at \(now)")
        }
    }
}
