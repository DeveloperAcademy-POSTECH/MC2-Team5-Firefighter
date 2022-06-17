//
//  UIColor+Extension.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

extension UIColor {
    
    // MARK: - red
    
    static var mainRed: UIColor {
        return UIColor(hex: "#E13B2D")
    }
    
    static var shadowRed: UIColor {
        return UIColor(hex: "#A4291F")
    }
    
    static var darkRed: UIColor {
        return UIColor(hex: "#C84842")
    }
    
    // MARK: - grey
    
    static var backgroundGrey: UIColor {
        return UIColor(hex: "#242424")
    }
    
    static var subBackgroundGrey: UIColor {
        return UIColor(hex: "#5A5A5A")
    }
    
    static var grey001: UIColor {
        return UIColor(hex: "#6F6F6F")
    }
    
    static var grey002: UIColor {
        return UIColor(hex: "#A5A5A5")
    }
    
    static var grey003: UIColor {
        return UIColor(hex: "#D9D9D9")
    }
    
    static var grey004: UIColor {
        return UIColor(hex: "#DFDFDF")
    }
    
    static var grey005: UIColor {
        return UIColor(hex: "#717174")
    }
    
    static var grey006: UIColor {
        return UIColor(hex: "#353536")
    }
    
    static var grey007: UIColor {
        return UIColor(hex: "#939393")
    }
    
    // MARK: - darkGrey
    
    static var darkGrey001: UIColor {
        return UIColor(hex: "#3D3D3D")
    }
    
    static var darkGrey002: UIColor {
        return UIColor(hex: "#242424")
    }
    
    static var darkGrey003: UIColor {
        return UIColor(hex: "#343434")
    }
    
    static var darkGrey004: UIColor {
        return UIColor(hex: "#616161")
    }
    
    static var darkGrey005: UIColor {
        return UIColor(hex: "#828282")
    }
    
    // MARK: - orange
    
    static var subOrange: UIColor {
        return UIColor(hex: "#EAB33D")
    }
    
    // MARK: - blue
    
    static var subBlue: UIColor {
        return UIColor(hex: "#3472EB")
    }
    
    static var backgroundBlue: UIColor {
        return UIColor(hex: "#8BC4E7")
    }
    
    // MARK: - yellow
    
    static var yellow: UIColor {
        return UIColor(hex: "#EDC845")
    }
    
    static var shadowYellow: UIColor {
        return UIColor(hex: "#C7A83C")
    }
    
    // MARK: - badge
    
    static var badgeBeige: UIColor {
        return UIColor(hex: "#FFDBBA")
    }
    
    // MARK: - character
    
    static var characterYellow: UIColor {
        return UIColor(hex: "#EFDC4A")
    }
    
    static var characterRed: UIColor {
        return UIColor(hex: "#D03D40")
    }
    
    static var characterOrange: UIColor {
        return UIColor(hex: "#D78041")
    }
    
    static var characterBlue: UIColor {
        return UIColor(hex: "#0811CD")
    }
    
    static var characterLightGreen: UIColor {
        return UIColor(hex: "#8AB542")
    }
    
    static var characterPurple: UIColor {
        return UIColor(hex: "#8B3183")
    }
    
    static var characterGreen: UIColor {
        return UIColor(hex: "#43844E")
    }
    
    static var characterPink: UIColor {
        return UIColor(hex: "#E46593")
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
