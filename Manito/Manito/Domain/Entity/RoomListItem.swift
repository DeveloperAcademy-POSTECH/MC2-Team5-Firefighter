//
//  RoomListItem.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

///
/// 메인 뷰에서 사용하는 방 정보
/// 데이터 모델 Entity 입니다.
///
struct RoomListItem {
    /// 방의 고유 id값
    let id: Int
    /// 방 제목
    let title: String
    /// 현재 진행 상태
    let state: RoomStatus
    /// 현재 참여한 인원 (옵션)
    let participatingCount: Int?
    /// 방 참여 가능한 최대 인원
    let capacity: Int
    /// 시작 날짜 ex) 2023.09.12
    let startDate: String
    /// 종료 날짜 ex) 2023.09.16
    let endDate: String

    init(
        id: Int,
        title: String,
        state: String,
        participatingCount: Int? = nil,
        capacity: Int,
        startDate: String,
        endDate: String
    ) {
        self.id = id
        self.title = title
        self.participatingCount = participatingCount
        self.capacity = capacity
        self.startDate = startDate
        self.endDate = endDate
        self.state = RoomStatus(rawValue: state) ?? .PRE
    }
}

extension RoomListItem {
    /// 시작날짜와 종료날짜를 ~을 포함한 String 형식으로 반환
    /// ex) 2023.09.12 ~ 2023.09.16
    var dateRangeText: String {
        return self.startDate + " ~ " + self.endDate
    }
    
    /// 시작 날짜가 오늘보다 과거인지
    var isStartDatePast: Bool {
        guard let startDate = self.startDate.toDefaultDate else { return true }
        return startDate.isPast
    }
}

extension RoomListItem: Equatable {
    static let testRoomListItem = RoomListItem(
        id: 1,
        title: "테스트타이틀",
        state: "PRE",
        participatingCount: 5,
        capacity: 5,
        startDate: "2023.01.01",
        endDate: "2023.01.05"
    )
}
