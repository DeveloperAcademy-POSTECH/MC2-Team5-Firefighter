//
//  MessageListItem.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

///
/// 쪽지, 함께 했던 기억 화면에서 쪽지 내용에 대한 정보들을 반환하는
/// 데이터 모델 Entity 입니다.
///

struct MessageListItem: Hashable {
    /// 쪽지의 id 정보
    let id: Int
    /// 쪽지의 내용(옵션)
    let content: String?
    /// 쪽지에 포함된 사진(옵션)
    let imageUrl: String?
    /// 쪽지를 보낸 날짜
    let createdDate: String
    /// 쪽지에 해당하는 미션(옵션 - 미션을 추가하지 않았던 v1 API)
    let missionInfo: IndividualMissionDTO?
    /// 쪽지 신고 가능 정보(받은 쪽지만 신고 가능)
    let canReport: Bool

    // MARK: - Custom property

    /// 쪽지 생성 날짜와 오늘 날짜가 동일한지
    var isToday: Bool {
        return Date().letterDateToString == createdDate
    }
    /// 쪽지의 날짜를 반환(당일이라면 "오늘" 반환)
    var date: String {
        return self.isToday ? "오늘" : createdDate
    }
    /// 쪽지에 해당하는 개별 미션 반환(없으면 nil 반환)
    var mission: String? {
        guard let mission = missionInfo?.content else { return nil }

        return "\(date)의 개별미션\n[\(mission)]"
    }
}
