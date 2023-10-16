//
//  Memory.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/16/23.
//

import Foundation

///
/// 함께 했던 기억 화면 관련 내용을 반환하는
/// 데이터 모델 Entity입니다.
///

struct Memory {
    /// 마니또와의 추억
    let memoriesWithManitto: MemoryItem?
    /// 마니띠와의 추억
    let memoriesWithManittee: MemoryItem?
}

struct MemoryItem {
    /// 마니또나 마니띠의 정보
    let member: MemberInfo
    /// 마니또, 마니띠와 주고 받았던 쪽지 내용
    let messages: [MessageListItem]
}
