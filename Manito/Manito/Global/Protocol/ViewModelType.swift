//
//  ViewModelType.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/20.
//

import Foundation

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output

    func transform(from input: Input) -> Output
}
