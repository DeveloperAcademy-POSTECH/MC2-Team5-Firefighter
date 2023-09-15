//
//  ParticipateRoomInfo.swift
//  Manito
//
//  Created by 이성호 on 2023/09/05.
//

import Foundation

/// 초대코드 입력 시 코드에 맞는 방 데이터 입니다.

struct ParticipatedRoomInfo {
    /// 방 id
    let id: Int
    /// 방 제목
    let title: String
    /// 방 참여 가능 인원 수
    let capacity: Int
    /// 현재 방 참가 인원 수
    let participatingCount: Int
    /// 방 시작 날짜
    let startDate: String
    /// 방 종료 날짜
    let endDate: String
}
