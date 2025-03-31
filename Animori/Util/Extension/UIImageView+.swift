//
//  UIImageView+.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import UIKit

extension UIImageView {
    
    func setImage(with url: String?) {
        guard let url,
              let imageUrl = URL(string: url) else { return }
        
        Task {
            do {
                let data = try await ImageClient.shared.requestImage(with: imageUrl)
                self.image = UIImage(data: data)
            } catch {
                self.image = UIImage(systemName: "arrow.down.app.dashed.trianglebadge.exclamationmark")
            }
        }
    }
    
}
