//
//  UIViewController+Alert.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/06.
//

import UIKit

extension UIViewController {
    func makeAlert(title: String,
                   message: String? = nil,
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
                          okTitle: String = "확인",
                          cancelTitle: String = "취소",
                          okStyle: UIAlertAction.Style = .destructive,
                          okAction: ((UIAlertAction) -> Void)?,
                          cancelAction: ((UIAlertAction) -> Void)? = nil,
                          completion : (() -> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: cancelAction)
        alertViewController.addAction(cancelAction)

        let okAction = UIAlertAction(title: okTitle, style: okStyle, handler: okAction)
        alertViewController.addAction(okAction)

        self.present(alertViewController, animated: true, completion: completion)
    }

    func makeActionSheet(title: String? = nil,
                         message: String? = nil,
                         actionTitles:[String?],
                         actionStyle:[UIAlertAction.Style],
                         actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: actionStyle[index], handler: actions[index])
            alert.addAction(action)
        }

        self.present(alert, animated: true, completion: nil)
    }
}
