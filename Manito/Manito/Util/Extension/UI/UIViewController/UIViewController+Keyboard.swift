//
//  UIViewController+Keyboard.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/06.
//

import UIKit

extension UIViewController {
    func hidekeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func endEditingView() {
        view.endEditing(true)
    }
}
