//
//  ToastPopupView.swift
//  Manito
//
//  Created by LeeSungHo on 2022/11/15.
//

import UIKit

import SnapKit

struct ToastView {
    static func showToast(message: String, controller: UIViewController) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = .grey001
        toastLabel.textColor = .black
        toastLabel.font = .font(.regular, ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        controller.view.addSubview(toastLabel)

        toastLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(150)
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }

        UIView.animate(withDuration: 0.7, animations: {
            toastLabel.alpha = 0.8
        }, completion: { isCompleted in
            UIView.animate(withDuration: 0.7, delay: 0.5, animations: {
                toastLabel.alpha = 0
            }, completion: { isCompleted in
                toastLabel.removeFromSuperview()
            })
        })
    }
    
    static func showToast(message: String, view: UIView) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = .grey001
        toastLabel.textColor = .black
        toastLabel.font = .font(.regular, ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)

        toastLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(150)
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }

        UIView.animate(withDuration: 0.7, animations: {
            toastLabel.alpha = 0.8
        }, completion: { isCompleted in
            UIView.animate(withDuration: 0.7, delay: 0.5, animations: {
                toastLabel.alpha = 0
            }, completion: { isCompleted in
                toastLabel.removeFromSuperview()
            })
        })
    }

    static func showToast(code: String, message: String, controller: UIViewController) {
        UIPasteboard.general.string = code
        showToast(message: TextLiteral.detailWaitViewControllerCopyCode, controller: controller)
    }
    
    static func showToast(code: String, message: String, view: UIView) {
        UIPasteboard.general.string = code
        showToast(message: TextLiteral.detailWaitViewControllerCopyCode, view: view)
    }
}
