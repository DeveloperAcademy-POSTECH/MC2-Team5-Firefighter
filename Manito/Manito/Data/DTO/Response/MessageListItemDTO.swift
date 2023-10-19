//
//  MessageListItemDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

///
/// 쪽지, 함께 했던 기억 화면에서 쪽지 내용에 대한 정보들을 반환하는
/// 데이터 모델 DTO입니다.
///

struct MessageListItemDTO: Decodable {
    /// 쪽지의 id 정보
    let id: Int?
    /// 쪽지의 내용(옵션)
    let content: String?
    /// 쪽지에 포함된 사진(옵션)
    let imageUrl: String?
    /// 쪽지를 보낸 날짜
    let createdDate: String?
    /// 쪽지에 해당하는 미션(옵션 - 미션을 추가하지 않았던 v1 API)
    let missionInfo: IndividualMissionDTO?
}

extension MessageListItemDTO {
    func toMessageListItem(canReport: Bool) async -> MessageListItem {
        return await MessageListItem(id: self.id ?? 0,
                               content: self.content,
                               imageUrl: self.verifiedImageURL(),
                               createdDate: self.createdDate ?? "",
                               missionInfo: self.missionInfo,
                               canReport: canReport)
    }
    
    // MARK: - Private - func
    
    /// DB에 이미지가 없는 imageURL를 걸러내고 검증된 imageURL만 반환
    private func verifiedImageURL() async -> String? {
        do {
            guard let imageURL = self.imageUrl else { return nil }
            guard let url = URL(string: imageURL) else { return nil }
            
            let (_, response) = try await URLSession.shared.data(from: url)
            guard let urlResponse = response as? HTTPURLResponse else { return nil }
            
            switch urlResponse.statusCode {
            case 200..<300: return self.imageUrl
            default: return nil
            }
        } catch {
            return nil
        }
    }
}
