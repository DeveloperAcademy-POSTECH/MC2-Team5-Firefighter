//
//  LoginInfo.swift
//  Manito
//
//  Created by COBY_PRO on 11/9/23.
//

import Foundation

///
/// 로그인/회원가입 시에 유저 데이터를 반환하는
/// 데이터 모델 Entity입니다.
///

struct LoginInfo {
    let accessToken: String
    let refreshToken: String
    let nickname: String
    let isNewMember: Bool
    let userSettingDone: Bool
}
