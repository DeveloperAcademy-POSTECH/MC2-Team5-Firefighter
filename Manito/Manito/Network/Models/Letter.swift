//
//  Letter.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/12.
//

import Foundation

struct Letter: Codable {
    var image: String?
    var content: String?
}

// FIXME: - 더미로 넣은 Letter 데이터

var receivedLetters: [Letter] = [
    Letter(content: "c5 15번 사물함\n비밀번호: 4860\n열어보세용~"),
    Letter(image: "dummy", content: "오늘 구름을 봤는데 고양이를 너무 닮아서 귀여워서 보내드려요~ 오늘 하루도 화이팅!!"),
    Letter(image: "dummy"),
    Letter(content: "c5 15번 사물함\n비밀번호: 4860\n열어보세용~"),
    Letter(image: "dummy", content: "오늘구름들을봤는데요오늘구름들을봤는데요오늘구름들을봤는데요오늘구름들을봤는데요오늘구름들을봤는데요오늘구름들을봤는데요오늘구름들을봤는데요오늘구름들을봤는데요오늘구름들을봤는데요오늘구름들을봤는데요"),
    Letter(image: "dummy")
]

var sentLetters: [Letter] = [
    Letter(content: "마니또 화이팅!"),
    Letter(image: "dummy", content: "아자자")
]
