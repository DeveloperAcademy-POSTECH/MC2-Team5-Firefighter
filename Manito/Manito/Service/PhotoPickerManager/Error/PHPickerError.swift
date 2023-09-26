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
        // FIXME: - 수정할 예정 TextLiteral 머지 이후에!
        case .deniedAuthorization: return "사진첩에 접근할 권한이 없습니다."
        case .cantloadPhoto: return TextLiteral.letterPhotoViewFail
        case .cantloadDevice: return TextLiteral.letterPhotoViewDeviceFail
        case .cantOpenSetting: return TextLiteral.letterPhotoViewSettingFail
        }
    }
}
