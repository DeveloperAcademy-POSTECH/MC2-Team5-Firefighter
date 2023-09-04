//
//  LetterDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

///
/// 쪽지 화면에서 받은 쪽지, 보낸 쪽지 정보들을 반환하는
/// 데이터 모델 DTO입니다.
///

struct LetterDTO: Decodable {
    /// 총 쪽지 개수
    let count: Int?
    /// 마니띠 정보
    let manittee: UserInfoDTO?
    /// 쪽지 내용에 대한 자세한 정보
    let messages: [MessageListItemDTO]
}
