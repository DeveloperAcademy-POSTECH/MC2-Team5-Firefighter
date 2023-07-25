//
//  UIViewController+Combine.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/21.
//

import Combine
import UIKit

extension UIViewController {
    var viewDidLoadPublisher: AnyPublisher<Void, Never> {
        let selector = #selector(UIViewController.viewDidLoad)
        return Just(selector)
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
}
