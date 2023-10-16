//
//  SplashUsecase.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/16/23.
//

import Combine
import Foundation

protocol SplashUsecase {
    associatedtype EntryType
    
    var entryType: EntryType { get set }
}

final class SplashUsecaseImpl: SplashUsecase {
    
    enum EntryType {
        case login
        case nickname
        case main
    }
    
    // MARK: - property
    
    lazy var entryType: EntryType = self.initEntryType()
    
    private let isLogin: Bool = UserDefaultStorage.isLogin
    private let isSetNickname: Bool = (UserDefaultStorage.nickname != "")
    private let isSetFCMToken: Bool = UserDefaultStorage.isSetFcmToken
    
    // MARK: - Private - func
    
    private func initEntryType() -> EntryType {
        if self.isLogin {
            if !self.isSetNickname { return .nickname }
            return .main
        } else {
            return .login
        }
    }
}
