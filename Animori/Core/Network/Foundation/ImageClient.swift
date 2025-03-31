//
//  ImageClient.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import Foundation

final class ImageClient {
    
    static let shared = ImageClient()
    
    private let session: URLSession
    
    private let memoryCapacity = 10 * 1024 * 1024 // ram에 저장 가능한 최대 크기
    private let diskCapacity = 100 * 1024 * 1024 // 디스크에 저장 가능한 최대 크기
    
    private init() {
        let urlCache = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity,
            diskPath: "imageCache" // 디스크에 저장될 경로
        )
        
        let config = URLSessionConfiguration.default
        config.urlCache = urlCache
        config.requestCachePolicy = .returnCacheDataElseLoad // 캐시 된 데이터가 있으면 사용
        
        session = URLSession(configuration: config)
    }
    
    func requestImage(with url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        
        if let cached = URLCache.shared.cachedResponse(for: request) {
            return cached.data
        }
        
        let (data, response) = try await session.data(for: request)
    
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw NSError(domain: "ImageClient", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "유효하지 않은 응답"])
        }
        return data
    }
}
