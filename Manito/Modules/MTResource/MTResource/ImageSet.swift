//
//  ImageSet.swift
//  MTResource
//
//  Created by SHIN YOON AH on 2023/09/10.
//

import UIKit

public enum ImageSet {

    public enum Icon {
        static var list: UIImage { .load(name: "btnList") }
        static var manitti: UIImage { .load(name: "btnManiTti") }
        static var newRoom: UIImage { .load(name: "btnNewRoom") }
        static var insta: UIImage { .load(name: "ic_insta")}
        static var report: UIImage { .load(name: "ic_report")}
        static var more: UIImage { .load(name: "ic_more")}
        static var letterMissionInfo: UIImage { .load(name: "ic_letterInfo")}
        static var missionInfo: UIImage { .load(name: "ic_missionInfo")}
        static var right: UIImage { .load(name: "ic_right")}
        static var save: UIImage { .load(name: "ic_save")}
        static var pencil: UIImage { .load(name: "ic_pencil") }
    }

    public enum Button {
        static var back: UIImage { .load(name: "ic_back") }
        static var xmark: UIImage { .load(name: "ic_exit") }
        static var setting: UIImage { .load(name: "ic_setting") }
        static var camera: UIImage { .load(name: "ic_camera") }
    }

    public enum Image {
        static var appIcon: UIImage { .load(name: "imgAppIcon")}
        static var logo: UIImage { .load(name: "imgLogo") }
        static var textLogo: UIImage { .load(name: "imgTextLogo")}
        static var background: UIImage { .load(name: "imgBackground") }
        static var devBackground: UIImage { .load(name: "imgDevBackground") }
        static var star: UIImage { .load(name: "imgStar") }
        static var sliderThumb: UIImage { .load(name: "btnSliderThumb") }
        static var characters: UIImage { .load(name: "img_characters") }
        static var codeBackground: UIImage { .load(name: "imgCodeBackground") }
        static var commonMisson: UIImage { .load(name: "imgCommonMisson") }
        static var enterRoom: UIImage { .load(name: "imgEnterRoom") }
        static var guideBox: UIImage { .load(name: "img_guideBox") }
        static var ma: UIImage { .load(name: "imgMa") }
        static var ni: UIImage { .load(name: "imgNi") }
        static var tto: UIImage { .load(name: "imgTto") }
        static var chemi: UIImage { .load(name: "imgMaChemi") }
        static var coby: UIImage { .load(name: "imgMaCoby") }
        static var duna: UIImage { .load(name: "imgMaDuna") }
        static var dinner: UIImage { .load(name: "imgMaDinner") }
        static var hoya: UIImage { .load(name: "imgMaHoya") }
        static var livvy: UIImage { .load(name: "imgMaLivvy") }
        static var daon: UIImage { .load(name: "imgMaDaon") }
        static var leo: UIImage { .load(name: "imgMaLeo") }
        static var characterPink: UIImage { .load(name: "imgCharacterPink") }
        static var characterBrown: UIImage { .load(name: "imgCharacterBrown") }
        static var characterBlue: UIImage { .load(name: "imgCharacterBlue") }
        static var characterRed: UIImage { .load(name: "imgCharacterRed") }
        static var characterOrange: UIImage { .load(name: "imgCharacterOrange") }
        static var characterYellow: UIImage { .load(name: "imgCharacterYellow") }
        static var characterLightGreen: UIImage { .load(name: "imgCharacterLightGreen") }
        static var characterHeavyPink: UIImage { .load(name: "imgCharacterHeavyPink") }
        static var characterPurple: UIImage { .load(name: "imgCharacterPurple") }
    }

    public enum Gif {
        static var logo = "logo"
        static var joystick = "joystick"
        static var capsule = "capsule"
        static var ma = "gifMa"
        static var ni = "gifNi"
        static var tto = "gifTto"
    }

}

public extension UIImage {
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
}
