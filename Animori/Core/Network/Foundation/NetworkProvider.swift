//
//  NetworkProvider.swift
//  Animori
//
//  Created by 이빈 on 3/30/25.
//

import Foundation
import RxSwift

struct NetworkProvider<E: EndPoint>: Sendable {
    func request<T: Decodable>(_ endPoint: E) -> Single<T> {
        return Single.create { single in
            let task = Task {
                do {
                    let request = try endPoint.asURLRequest()
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200..<300).contains(httpResponse.statusCode) else {
                        single(.failure(endPoint.error((response as? HTTPURLResponse)?.statusCode, data: data)))
                        return
                    }
                    
                    let decodedData = try endPoint.decoder.decode(T.self, from: data)
                    single(.success(decodedData))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
}
