//
//  UserDefault+Extension.swift
//  Manito
//
//  Created by 이성호 on 2022/09/07.
//

import Foundation

extension UserDefaults {
    var nickname: String? {
        get {
            let nickname = UserDefaults.standard.string(forKey: TextLiteral.userNickname)
            return nickname
        }
        set {
            UserDefaults.standard.set(newValue, forKey: TextLiteral.userNickname)
        }
    }
}
