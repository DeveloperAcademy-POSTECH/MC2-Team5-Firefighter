//
//  Character.swift
//  Manito
//
//  Created by COBY_PRO on 2022/09/04.
//

import UIKit

enum Character: CaseIterable {
    case imgCharacterPink
    case imgCharacterBrown
    case imgCharacterBlue
    case imgCharacterRed
    case imgCharacterOrange
    case imgCharacterYellow
    case imgCharacterLightGreen
    case imgCharacterHeavyPink
    case imgCharacterPurple
    
    var color: UIColor {
        switch self {
        case .imgCharacterPink:
            return UIColor.characterYellow
        case .imgCharacterBrown:
            return UIColor.characterRed
        case .imgCharacterBlue:
            return UIColor.characterOrange
        case .imgCharacterRed:
            return UIColor.characterBlue
        case .imgCharacterOrange:
            return UIColor.characterLightGreen
        case .imgCharacterYellow:
            return UIColor.characterPurple
        case .imgCharacterLightGreen:
            return UIColor.characterGreen
        case .imgCharacterHeavyPink:
            return UIColor.backgroundGrey
        case .imgCharacterPurple:
            return UIColor.characterPink
        }
    }

    var image: UIImage {
        switch self {
        case .imgCharacterPink:
            return ImageLiterals.imgCharacterPink
        case .imgCharacterBrown:
            return ImageLiterals.imgCharacterBrown
        case .imgCharacterBlue:
            return ImageLiterals.imgCharacterBlue
        case .imgCharacterRed:
            return ImageLiterals.imgCharacterRed
        case .imgCharacterOrange:
            return ImageLiterals.imgCharacterOrange
        case .imgCharacterYellow:
            return ImageLiterals.imgCharacterYellow
        case .imgCharacterLightGreen:
            return ImageLiterals.imgCharacterLightGreen
        case .imgCharacterHeavyPink:
            return ImageLiterals.imgCharacterHeavyPink
        case .imgCharacterPurple:
            return ImageLiterals.imgCharacterPurple
        }
    }
}
