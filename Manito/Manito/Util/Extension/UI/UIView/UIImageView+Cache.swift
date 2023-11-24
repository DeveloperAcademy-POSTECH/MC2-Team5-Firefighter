//
//  UIImageView+Cache.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/09/07.
//

import UIKit

extension UIImageView {
    func loadImageUrl(_ url: String) {
        DispatchQueue.global(qos: .background).async {
            let cachedKey = NSString(string: url)
            
            ImageCacheManager.shared.totalCostLimit = 50_000_000
            
            if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
                DispatchQueue.main.async {
                    self.image = cachedImage
                }
                return
            }
            
            guard let url = URL(string: url) else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                // FIXME: - 데이터베이스에서 이미지가 날라가면서 URL은 존재하는데 IMAGE가 없는 경우가 발생했습니다.
                // Error가 발생하는 경우를 후에 추가하겠습니다.
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                    self.image = image
                }
            }.resume()
        }
    }
}
