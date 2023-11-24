//
//  URLLiteral.swift
//  Manito
//
//  Created by 이성호 on 2022/09/06.
//

import Foundation

enum URLLiteral {
    enum Setting {
        static let personalInformation: String = "https://torpid-spy-8e4.notion.site/767e80eea1734539aead3b814016b361"
        static let termsOfService: String = "https://torpid-spy-8e4.notion.site/445bd6a8c8dc459d915158935dcc3298"
    }
    
    enum Memory {
        static let instagram: String = "instagram-stories://share?source_application=\(Bundle.main.instagramAppID)"
        static let instagramBundle: String = "com.instagram.sharedSticker.stickerImage"
    }
}
