//
//  UserDefaultHandler.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/08/30.
//

import Foundation

struct UserDefaultHandler {
    static func clearAllData() {
        UserData<Any>.clearAll()
    }
    
    static func setUserID(userID: String) {
        UserData.setValue(userID, forKey: .userID)
    }
    
    static func setAccessToken(accessToken: String) {
        UserData.setValue(accessToken, forKey: .accessToken)
    }
    
    static func setRefreshToken(refreshToken: String) {
        UserData.setValue(refreshToken, forKey: .refreshToken)
    }
    
    static func setNickname(nickname: String) {
        UserData.setValue(nickname, forKey: .nickname)
    }
}
