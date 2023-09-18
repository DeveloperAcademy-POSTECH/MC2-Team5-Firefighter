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
        case .pink: return UIImage.Image.characterPink
        case .brown: return UIImage.Image.characterBrown
        case .blue: return UIImage.Image.characterBlue
        case .red: return UIImage.Image.characterRed
        case .orange: return UIImage.Image.characterOrange
        case .yellow: return UIImage.Image.characterYellow
        case .lightGreen: return UIImage.Image.characterLightGreen
        case .heavyPink: return UIImage.Image.characterHeavyPink
        case .purple: return UIImage.Image.characterPurple
        }
    }
}
