//
//  FontSet.swift
//  MTResource
//
//  Created by SHIN YOON AH on 2023/09/10.
//

import UIKit

public enum AppFontName: String {
    case regular = "DungGeunMo"
}

public extension UIFont {
    static func font(_ style: AppFontName, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}
