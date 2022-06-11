//
//  UIColor+Extension.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

extension UIColor {
    static var mainBabyYellow: UIColor {
        return UIColor(hex: "#FFED8B")
    }
    static var waitBackgroundColor: UIColor {
        return UIColor(hex: "#FFDBBA")
    }
    static var waitTextColor: UIColor {
        return UIColor(hex: "#616161")
    }
    // MARK: 변수명 뭘로 하는게 좋을까요
    static var grey4: UIColor {
        return UIColor(hex: "#DFDFDF")
    }
    static var backgroundColor: UIColor {
        return UIColor(hex: "#242424")
    }
    static var durationBackgroundColor: UIColor {
        return UIColor(hex: "#8F3B38")
    }
    static var copyCodeTextColor: UIColor {
        return UIColor(hex: "#3472EB")
    }
    
    static var grey3: UIColor {
        return UIColor(hex: "3D3D3D")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
