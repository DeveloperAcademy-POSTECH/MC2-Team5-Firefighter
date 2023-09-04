//
//  UserInfoDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

///
/// User 정보들을 반환하는 데이터 모델 DTO입니다.
///

struct UserInfoDTO: Decodable {
    /// User Identifier
    let id: String?
    /// User 닉네임
    let nickname: String?
}
