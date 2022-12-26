//
//  ImageLiteral.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

enum ImageLiterals {
    
    // MARK: - icon
    
    static var icList: UIImage { .load(name: "btnList") }
    static var icManiTti: UIImage { .load(name: "btnManiTti") }
    static var icNewRoom: UIImage { .load(name: "btnNewRoom") }
    static var icBack: UIImage { .load(name: "ic_back")}
    static var icInsta: UIImage { .load(name: "ic_insta")}
    static var icReport: UIImage { .load(name: "ic_report")}
    static var icMore: UIImage { .load(name: "ic_more")}
    static var icLetterInfo: UIImage { .load(name: "ic_letterInfo")}
    static var icMissionInfo: UIImage { .load(name: "ic_missionInfo")}
    static var icRight: UIImage { .load(name: "ic_right")}
    static var icSave: UIImage { .load(name: "ic_save")}
    
    // MARK: - button
    
    static var btnBack: UIImage { .load(name: "ic_back") }
    static var btnXmark: UIImage { .load(name: "ic_exit") }
    static var btnSetting: UIImage { .load(name: "ic_setting") }
    static var btnCamera: UIImage { .load(name: "ic_camera") }

    // MARK: - image
    
    static var imgAppIcon: UIImage { .load(name: "imgAppIcon")}
    static var imgLogo: UIImage { .load(name: "imgLogo") }
    static var imgTextLogo: UIImage { .load(name: "imgTextLogo")}
    static var imgBackground: UIImage { .load(name: "imgBackground") }
    static var imgDevBackground: UIImage { .load(name: "imgDevBackground") }
    static var imgStar: UIImage { .load(name: "imgStar") }
    static var imageSliderThumb: UIImage { .load(name: "btnSliderThumb") }
    static var imgCharacters: UIImage { .load(name: "img_characters") }
    static var imgCodeBackground: UIImage { .load(name: "imgCodeBackground") }
    static var imgCommonMisson: UIImage { .load(name: "imgCommonMisson") }
    static var imgEnterRoom: UIImage { .load(name: "imgEnterRoom") }
    static var imgGuideBox: UIImage { .load(name: "img_guideBox") }
    static var imgMa: UIImage { .load(name: "imgMa") }
    static var imgNi: UIImage { .load(name: "imgNi") }
    static var imgTto: UIImage { .load(name: "imgTto") }
    static var imgMaChemi: UIImage { .load(name: "imgMaChemi") }
    static var imgMaCoby: UIImage { .load(name: "imgMaCoby") }
    static var imgMaDuna: UIImage { .load(name: "imgMaDuna") }
    static var imgMaDinner: UIImage { .load(name: "imgMaDinner") }
    static var imgMaHoya: UIImage { .load(name: "imgMaHoya") }
    static var imgMaLivvy: UIImage { .load(name: "imgMaLivvy") }
    static var imgMaDaon: UIImage { .load(name: "imgMaDaon") }
    static var imgMaLeo: UIImage { .load(name: "imgMaLeo") }
    
    // MARK: - gif
    
    static var gifLogo = "logo"
    static var gifJoystick = "joystick"
    static var gifCapsule = "capsule"
    static var gifMa = "gifMa"
    static var gifNi = "gifNi"
    static var gifTto = "gifTto"
    
    // MARK: - character
    static var imgCharacterPink: UIImage { .load(name: "imgCharacterPink") }
    static var imgCharacterBrown: UIImage { .load(name: "imgCharacterBrown") }
    static var imgCharacterBlue: UIImage { .load(name: "imgCharacterBlue") }
    static var imgCharacterRed: UIImage { .load(name: "imgCharacterRed") }
    static var imgCharacterOrange: UIImage { .load(name: "imgCharacterOrange") }
    static var imgCharacterYellow: UIImage { .load(name: "imgCharacterYellow") }
    static var imgCharacterLightGreen: UIImage { .load(name: "imgCharacterLightGreen") }
    static var imgCharacterHeavyPink: UIImage { .load(name: "imgCharacterHeavyPink") }
    static var imgCharacterPurple: UIImage { .load(name: "imgCharacterPurple") }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
    
    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }
    
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
