//
//  IndividualMission.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/09/02.
//

import Foundation

struct IndividualMission: Decodable, Hashable {
    let id: Int
    let content: String
}

extension IndividualMission: Equatable {
    static let testIndividualMission = IndividualMission(id: 1, content: "테스트미션")
}
