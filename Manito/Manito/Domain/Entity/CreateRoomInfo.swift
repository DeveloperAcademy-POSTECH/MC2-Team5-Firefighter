//
//  CreateRoom.swift
//  Manito
//
//  Created by 이성호 on 11/1/23.
//

import Foundation

struct CreateRoomInfo {
    let title: String
    let capacity: Int
    let startDate: String
    let endDate: String
}

extension CreateRoomInfo {
    static let emptyCreateInfo: CreateRoomInfo = {
        return CreateRoomInfo(title: "",
                              capacity: 0,
                              startDate: "",
                              endDate: "")
    }()
    
    func toCreateRoomInfoDTO() -> CreatedRoomInfoRequestDTO {
        return CreatedRoomInfoRequestDTO(title: self.title,
                                         capacity: self.capacity,
                                         startDate: "20\(self.startDate)",
                                         endDate: "20\(self.endDate)")
    }
}
