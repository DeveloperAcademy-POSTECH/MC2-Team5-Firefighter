//
//  textFieldUsecase.swift
//  Manito
//
//  Created by 이성호 on 11/3/23.
//

import Foundation

protocol TextFieldUsecase {
    func cutTextByMaxCount(text: String, maxCount: Int) -> String
}

final class TextFieldUsecaseImpl: TextFieldUsecase {
    func cutTextByMaxCount(text: String, maxCount: Int) -> String {
        let isOverMaxCount = self.isOverMaxCount(titleCount: text.count, maxCount: maxCount)
        
        if isOverMaxCount {
            let endIndex = text.index(text.startIndex, offsetBy: maxCount)
            let fixedText = text[text.startIndex..<endIndex]
            return String(fixedText)
        }
        return text
    }
    
    private func isOverMaxCount(titleCount: Int, maxCount: Int) -> Bool {
        return titleCount > maxCount
    }
}
