//
//  LoginRequestDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let identityToken: String
    let fcmToken : String
}
