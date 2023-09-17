//
//  SettingViewController+MailComposeViewControllerDelegate.swift
//  Manito
//
//  Created by 이성호 on 2023/05/12.
//

import MessageUI

// MARK: - MFMailComposeViewControllerDelegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    func sendReportMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            let aenittoEmail = TextLiteral.Mail.aenittoEmail.localized()
            let messageBody = TextLiteral.Mail.inquiryMessage.localized(with: UserDefaultStorage.nickname, Date().description)
            composeViewController.mailComposeDelegate = self
            composeViewController.setToRecipients([aenittoEmail])
            composeViewController.setSubject(TextLiteral.Mail.inquiryTitle.localized())
            composeViewController.setMessageBody(messageBody, isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: TextLiteral.Mail.Error.title.localized(),
                                                   message: TextLiteral.Mail.Error.message.localized(),
                                                   preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: TextLiteral.Common.confirm.localized(), style: .default)
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
