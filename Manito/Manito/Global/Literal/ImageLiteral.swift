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
    
    // MARK: - button
    
    static var btnList: UIImage { .load(name: "btnList") }
    static var btnManiTti: UIImage { .load(name: "btnManiTti") }
    static var btnNewRoom: UIImage { .load(name: "btnNewRoom") }
    static var btnSliderThumb: UIImage { .load(name: "btnSliderThumb") }
    
    // MARK: - image
    
    static var imgLogo: UIImage { .load(name: "imgLogo") }
    static var imgTextLogo: UIImage { .load(name: "imgTextLogo")}
    static var imgBackground: UIImage { .load(name: "imgBackground") }
    static var imgStar: UIImage { .load(name: "imgStar") }
    static var imgCodeBackground: UIImage { .load(name: "imgCodeBackground") }
    static var imgCommonMisson: UIImage { .load(name: "imgCommonMisson") }
    static var imgEnterRoom: UIImage { .load(name: "imgEnterRoom") }
    static var imgMa: UIImage { .load(name: "imgMa") }
    static var imgNi: UIImage { .load(name: "imgNi") }
    static var imgTto: UIImage { .load(name: "imgTto") }
    static var imgMaChemi: UIImage { .load(name: "imgMaChemi") }
    static var imgMaCoby: UIImage { .load(name: "imgMaCoby") }
    static var imgMaDuna: UIImage { .load(name: "imgMaDuna") }
    static var imgMaDinner: UIImage { .load(name: "imgMaDinner") }
    static var imgMaHoya: UIImage { .load(name: "imgMaHoya") }
    static var imgMaLivvy: UIImage { .load(name: "imgMaLivvy") }
    
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
