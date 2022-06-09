//
//  ImageLiteral.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

enum ImageLiterals {
    
    // MARK: - icon
    
    static var icActivecheck: UIImage { .load(name: "ic_activecheck") }
    
    // MARK: - image
    
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
    
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
