//
//  ImageSet.swift
//  MTResource
//
//  Created by SHIN YOON AH on 2023/09/10.
//

import UIKit

public extension UIImage {

    enum Icon {
        public static var list: UIImage { .load(name: "btnList") }
        public static var manitti: UIImage { .load(name: "btnManiTti") }
        public static var newRoom: UIImage { .load(name: "btnNewRoom") }
        public static var insta: UIImage { .load(name: "ic_insta")}
        public static var report: UIImage { .load(name: "ic_report")}
        public static var more: UIImage { .load(name: "ic_more")}
        public static var letterMissionInfo: UIImage { .load(name: "ic_letterInfo")}
        public static var missionInfo: UIImage { .load(name: "ic_missionInfo")}
        public static var right: UIImage { .load(name: "ic_right")}
        public static var save: UIImage { .load(name: "ic_save")}
        public static var pencil: UIImage { .load(name: "ic_pencil") }
    }

    enum Button {
        public static var back: UIImage { .load(name: "ic_back") }
        public static var xmark: UIImage { .load(name: "ic_exit") }
        public static var setting: UIImage { .load(name: "ic_setting") }
        public static var camera: UIImage { .load(name: "ic_camera") }
    }

    enum Image {
        public static var appIcon: UIImage { .load(name: "imgAppIcon")}
        public static var logo: UIImage { .load(name: "imgLogo") }
        public static var textLogo: UIImage { .load(name: "imgTextLogo")}
        public static var background: UIImage { .load(name: "imgBackground") }
        public static var devBackground: UIImage { .load(name: "imgDevBackground") }
        public static var star: UIImage { .load(name: "imgStar") }
        public static var sliderThumb: UIImage { .load(name: "btnSliderThumb") }
        public static var characters: UIImage { .load(name: "img_characters") }
        public static var codeBackground: UIImage { .load(name: "imgCodeBackground") }
        public static var commonMisson: UIImage { .load(name: "imgCommonMisson") }
        public static var enterRoom: UIImage { .load(name: "imgEnterRoom") }
        public static var guideBox: UIImage { .load(name: "img_guideBox") }
        public static var ma: UIImage { .load(name: "imgMa") }
        public static var ni: UIImage { .load(name: "imgNi") }
        public static var tto: UIImage { .load(name: "imgTto") }
        public static var chemi: UIImage { .load(name: "imgMaChemi") }
        public static var coby: UIImage { .load(name: "imgMaCoby") }
        public static var duna: UIImage { .load(name: "imgMaDuna") }
        public static var dinner: UIImage { .load(name: "imgMaDinner") }
        public static var hoya: UIImage { .load(name: "imgMaHoya") }
        public static var livvy: UIImage { .load(name: "imgMaLivvy") }
        public static var daon: UIImage { .load(name: "imgMaDaon") }
        public static var leo: UIImage { .load(name: "imgMaLeo") }
        public static var characterPink: UIImage { .load(name: "imgCharacterPink") }
        public static var characterBrown: UIImage { .load(name: "imgCharacterBrown") }
        public static var characterBlue: UIImage { .load(name: "imgCharacterBlue") }
        public static var characterRed: UIImage { .load(name: "imgCharacterRed") }
        public static var characterOrange: UIImage { .load(name: "imgCharacterOrange") }
        public static var characterYellow: UIImage { .load(name: "imgCharacterYellow") }
        public static var characterLightGreen: UIImage { .load(name: "imgCharacterLightGreen") }
        public static var characterHeavyPink: UIImage { .load(name: "imgCharacterHeavyPink") }
        public static var characterPurple: UIImage { .load(name: "imgCharacterPurple") }
    }
    
}

public extension UIImage {
    static func load(name: String) -> UIImage {
        let bundle = BundleToken.bundle
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else {
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
}
