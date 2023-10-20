//
//  MemoryDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

///
/// 함께 했던 기억 화면 관련 내용을 반환하는
/// 데이터 모델 DTO입니다.
///

struct MemoryDTO: Decodable {
    /// 마니또와의 추억
    let memoriesWithManitto: MemoryItemDTO?
    /// 마니띠와의 추억
    let memoriesWithManittee: MemoryItemDTO?
}

extension MemoryDTO {
    func toMemory() async -> Memory {
        return await Memory(memoriesWithManitto: (self.memoriesWithManitto?.toMemoryItem())!,
                            memoriesWithManittee: (self.memoriesWithManittee?.toMemoryItem())!)
    }
}

struct MemoryItemDTO: Decodable {
    /// 마니또나 마니띠의 정보
    let member: MemberInfoDTO?
    /// 마니또, 마니띠와 주고 받았던 쪽지 내용
    let messages: [MessageListItemDTO]?
}

extension MemoryItemDTO {
    func toMemoryItem() async -> MemoryItem {
        let memberInfo = MemberInfo(nickname: member?.nickname ?? "",
                                    colorIndex: member?.colorIndex ?? 0)
        var resultMessages: [MessageListItem] = []
        for message in self.messages ?? [] {
            resultMessages.append(await message.toMessageListItem(canReport: false))
        }
        return MemoryItem(member: memberInfo,
                          messages: resultMessages)
    }
}
