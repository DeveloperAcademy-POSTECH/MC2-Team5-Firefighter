//
//  BaseModel.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

struct BaseModel<T: Decodable>: Decodable {
    var data: T?
}
