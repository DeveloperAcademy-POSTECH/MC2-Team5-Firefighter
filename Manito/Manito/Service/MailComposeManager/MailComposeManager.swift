//
//  MailComposeManager.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/13/23.
//

import MessageUI

final class MailComposeManager: NSObject {
    
    // MARK: - property
    
    weak var viewController: UIViewController?
    
    // MARK: - func
    
    func sendMail(title: String, content: String) {
        if MFMailComposeViewController.canSendMail() {
            self.showMail(title: title, content: content)
        } else {
            self.showErrorAlert()
        }
    }
    
    // MARK: - Private - func
    
    private func showMail(title: String, content: String) {
        let controller = MFMailComposeViewController()
        let aenittoEmail = TextLiteral.Mail.aenittoEmail.localized()
        controller.mailComposeDelegate = self
        controller.setToRecipients([aenittoEmail])
        controller.setSubject(title)
        controller.setMessageBody(content, isHTML: false)
        self.viewController?.present(controller, animated: true)
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: TextLiteral.Mail.Error.title.localized(),
                                                message: TextLiteral.Mail.Error.message.localized(),
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: TextLiteral.Common.confirm.localized(), style: .default)
        alertController.addAction(confirmAction)
        self.viewController?.present(alertController, animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension MailComposeManager: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
