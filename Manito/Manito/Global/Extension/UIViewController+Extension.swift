//
//  UIViewController+Extension.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

extension UIViewController {
    func makeAlert(title: String,
                   message: String,
                   okAction: ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: completion)
    }

    func makeRequestAlert(title: String,
                          message: String,
                          okAction: ((UIAlertAction) -> Void)?,
                          cancelAction: ((UIAlertAction) -> Void)? = nil,
                          completion : (() -> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: cancelAction)
        alertViewController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
        alertViewController.addAction(okAction)

        self.present(alertViewController, animated: true, completion: completion)
    }
    
    func hidekeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
