//
//  LetterImageError.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/02/21.
//

import Foundation

enum LetterImageError: LocalizedError {
    case invalidImage
    case invalidPhotoLibrary
    case cantloadPhoto
}

extension LetterImageError {
    var errorDescription: String? {
        switch self {
        case .invalidImage: return TextLiteral.letterImageViewControllerErrorMessage
        case .invalidPhotoLibrary: return TextLiteral.letterImageViewControllerErrorMessage
        case .cantloadPhoto: return TextLiteral.letterPhotoViewFail
        }
    }
}
