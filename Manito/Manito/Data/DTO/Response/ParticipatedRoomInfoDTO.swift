//
//  ParticipatedRoomInfoDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

///
/// 방 참가시 그 방의 정보들을 반환하는 데이터 모델 DTO 입니다.
///

struct ParticipatedRoomInfoDTO: Decodable {
    /// 방 id
    let id: Int?
    /// 방 제목
    let title: String?
    /// 방 참여 가능 인원 수
    let capacity: Int?
    /// 현재 방 참가 인원 수
    let participatingCount: Int?
    /// 방 시작 날짜
    let startDate: String?
    /// 방 종료 날짜
    let endDate: String?
}

extension ParticipatedRoomInfoDTO {
    func toParticipateRoomInfo() -> ParticipateRoomInfo {
        return ParticipateRoomInfo(id: self.id ?? 0,
                                   title: self.title ?? "",
                                   capacity: self.capacity ?? 0,
                                   participatingCount: self.participatingCount ?? 0,
                                   startDate: self.startDate ?? "",
                                   endDate: self.endDate ?? "")
    }
}
