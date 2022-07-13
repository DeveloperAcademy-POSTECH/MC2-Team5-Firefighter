//
//  RoomDTO.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

// FIXME: DTO 느낌으로 분리하는건 어떤지..??
struct RoomDTO: Encodable {
    let title: String
    let capacity: Int
    let startDate: String
    let endDate: String
}
