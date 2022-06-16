//
//  ImageLiteral.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

enum ImageLiterals {
    
    // MARK: - icon
    
    static var icBack: UIImage { .load(systemName: "chevron.backward") }
    static var icXmark: UIImage { .load(systemName: "xmark.circle.fill") }
    static var icSetting: UIImage { .load(systemName: "gearshape") }
    static var icExit: UIImage { .load(systemName: "rectangle.portrait.and.arrow.right") }
    static var icCamera: UIImage { .load(systemName: "camera.on.rectangle") }
    
    // MARK: - image
    
    // MARK: - gif
    
    static var gifLogo = "logo"
    
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
    
    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }
    
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
