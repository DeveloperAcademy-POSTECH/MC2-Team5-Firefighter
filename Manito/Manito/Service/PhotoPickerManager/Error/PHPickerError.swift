//
//  PHPickerError.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/27.
//

import Foundation

enum PHPickerError: LocalizedError {
    case deniedAuthorization
    case cantloadPhoto
    case cantloadDevice
    case cantOpenSetting
}

extension PHPickerError {
    var errorDescription: String? {
        switch self {
        case .deniedAuthorization: return TextLiteral.SendLetter.Error.photosAuthorizationMessage.localized()
        case .cantloadPhoto: return TextLiteral.SendLetter.Error.photoLoadMessage.localized()
        case .cantloadDevice: return TextLiteral.SendLetter.Error.deviceMessage.localized()
        case .cantOpenSetting: return TextLiteral.SendLetter.Error.settingMessage.localized()
        }
    }
}
