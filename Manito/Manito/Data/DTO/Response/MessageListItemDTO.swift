//
//  MessageListItemDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct MessageListItemDTO: Decodable {
    let id: Int?
    let content: String?
    let imageUrl: String?
    let createdDate: String?
    let missionInfo: IndividualMissionDTO?
}

extension MessageListItemDTO {
    func toMessageListItem(canReport: Bool) -> MessageListItem {
        return MessageListItem(id: self.id ?? 0,
                               content: self.content ?? "",
                               imageUrl: self.imageUrl ?? "",
                               createdDate: self.createdDate ?? "",
                               missionInfo: self.missionInfo ?? IndividualMissionDTO(id: 0, content: ""),
                               canReport: canReport)
    }
}
