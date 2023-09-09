//
//  DefaultCharacterType.swift
//  Manito
//
//  Created by COBY_PRO on 2022/09/04.
//

import UIKit

///
/// 기본 캐릭터를 세팅할 때 사용되는 `enum`
///

enum DefaultCharacterType: CaseIterable {
    case pink
    case brown
    case blue
    case red
    case orange
    case yellow
    case lightGreen
    case heavyPink
    case purple
    
    var backgroundColor: UIColor {
        switch self {
        case .pink: return UIColor.characterYellow
        case .brown: return UIColor.characterRed
        case .blue: return UIColor.characterOrange
        case .red: return UIColor.characterBlue
        case .orange: return UIColor.characterLightGreen
        case .yellow: return UIColor.characterPurple
        case .lightGreen: return UIColor.characterGreen
        case .heavyPink: return UIColor.backgroundGrey
        case .purple: return UIColor.characterPink
        }
    }

    var image: UIImage {
        switch self {
        case .pink: return ImageLiterals.imgCharacterPink
        case .brown: return ImageLiterals.imgCharacterBrown
        case .blue: return ImageLiterals.imgCharacterBlue
        case .red: return ImageLiterals.imgCharacterRed
        case .orange: return ImageLiterals.imgCharacterOrange
        case .yellow: return ImageLiterals.imgCharacterYellow
        case .lightGreen: return ImageLiterals.imgCharacterLightGreen
        case .heavyPink: return ImageLiterals.imgCharacterHeavyPink
        case .purple: return ImageLiterals.imgCharacterPurple
        }
    }
}
