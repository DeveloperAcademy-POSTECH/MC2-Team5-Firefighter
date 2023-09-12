//
//  UIFont+Extension.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

enum AppFontName: String {
    case regular = "DungGeunMo"
}

extension UIFont {
    static func font(_ style: AppFontName, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}
