//
//  UIImageView+.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import UIKit

extension UIImageView {
    
    func setImage(from urlString: String, placeholder: UIImage? = nil) -> Task<Void, Never>? {
        self.image = placeholder
        
        guard let imageUrl = URL(string: urlString) else {
            self.image = UIImage(systemName: "arrow.down.app.dashed.trianglebadge.exclamationmark")
            return nil
        }
        
        return Task { [weak self] in
            do {
                let data = try await ImageClient.shared.requestImage(with: imageUrl)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.image = image
                }
            } catch {
                DispatchQueue.main.async {
                    self?.image = UIImage(systemName: "arrow.down.app.dashed.trianglebadge.exclamationmark")
                }
            }
        }
    }
    
}
