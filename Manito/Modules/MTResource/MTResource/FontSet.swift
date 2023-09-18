//
//  FontSet.swift
//  MTResource
//
//  Created by SHIN YOON AH on 2023/09/10.
//

import UIKit

public enum AppFontName: String {
    case regular = "DungGeunMo"

    var path: String {
        switch self {
        case .regular: return "DungGeunMo.otf"
        }
    }

    public func register() {
        guard let url = BundleToken.bundle.url(forResource: self.path, withExtension: nil) else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }

    fileprivate func registerIfNeeded() {
        if !UIFont.fontNames(forFamilyName: self.rawValue).contains(self.rawValue) {
            register()
        }
    }
}

public extension UIFont {
    static func font(_ style: AppFontName, ofSize size: CGFloat) -> UIFont {
        style.registerIfNeeded()
        return UIFont(name: style.rawValue, size: size)!
    }
}
