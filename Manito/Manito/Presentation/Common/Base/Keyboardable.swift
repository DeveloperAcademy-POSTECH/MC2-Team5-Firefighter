//
//  Keyboardable.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/09/12.
//

import UIKit

protocol Keyboardable {
    func setupKeyboardGesture()
}

extension Keyboardable where Self: UIViewController {
    func setupKeyboardGesture() {
        self.hidekeyboardWhenTappedAround()
    }
}
