//
//  VerificationCode.swift
//  Manito
//
//  Created by LeeSungHo on 2022/08/31.
//

import Foundation

struct VerificationCode: Decodable {
    let id: Int?
    let title: String?
    let capacity: Int?
    let participatingCount: Int?
    let startDate: String?
    let endDate: String?
}
