//
//  IndividualMission.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/09/02.
//

import Foundation

///
/// 개별 미션에 대한 Entity
///
struct IndividualMission: Decodable, Hashable {
    /// 개별 미션 id 값
    let id: Int
    /// 개별 미션
    let content: String
}

extension IndividualMission: Equatable {
    static let testIndividualMission = IndividualMission(id: 1, content: "테스트미션")
}
