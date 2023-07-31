//
//  URLInfo+Extension.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/07/29.
//

import Foundation

extension Bundle {
    var productionURL: String {
        guard let file = self.path(forResource: "URLInfo", ofType: "plist") else { return "URLInfo 파일이 없습니다." }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["Production URL"] as? String else { fatalError("Production URL을 입력해 주세요") }
        return key
    }
    
    var developmentURL: String {
        guard let file = self.path(forResource: "URLInfo", ofType: "plist") else { return "URLInfo 파일이 없습니다." }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["Development URL"] as? String else { fatalError("Development URL을 입력해 주세요") }
        return key
    }
}
