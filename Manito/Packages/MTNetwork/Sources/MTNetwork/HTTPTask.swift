//
//  HTTPTask.swift
//  
//
//  Created by SHIN YOON AH on 2023/05/17.
//

import Foundation

public enum HTTPTask {

    /// A request with no additional data.
    case requestPlain

    /// A request body set with `Encodable` type
    case requestJSONEncodable(Encodable)

    /// A `URL` queryItem set with parameters.
    case requestParameters(_ parameters: [String: Any])

    /// A requests body set with encoded parameters combined with url parameters.
    case requestCompositeParameters(body: Encodable, query: [String: Any])

    /// A "multipart/form-data" upload task.
    case uploadMultipart([MultipartFormData])

    /// A "multipart/form-data" upload task  combined with url parameters.
    case uploadCompositeMultipart([MultipartFormData], query: [String: Any])
}
