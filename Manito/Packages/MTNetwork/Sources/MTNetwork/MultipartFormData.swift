//
//  MultipartFormData.swift
//  
//
//  Created by SHIN YOON AH on 2023/05/18.
//

import Foundation

public struct MultipartFormData {

    public enum FormDataProvider {
        case data(Data)
        case parameter([String: Any])
    }

    ///  The method being used for providing form data.
    let provider: FormDataProvider

    ///  The name.
    let name: String

    ///  The file name.
    let filename: String?

    ///  The MIME type
    let mimeType: String?

    ///  Verify that this is the first data.
    var hasInitialBoundary: Bool

    public init(
        provider: FormDataProvider,
        name: String = "",
        filename: String? = nil,
        mimeType: String? = nil
    ) {
        self.provider = provider
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
        self.hasInitialBoundary = false
    }
}
