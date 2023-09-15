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
            let aenittoEmail = TextLiteral.mailAenittoEmail
            let messageBody = TextLiteral.mailHelperMessage.localized(UserDefaultStorage.nickname, Date())
            composeViewController.mailComposeDelegate = self
            composeViewController.setToRecipients([aenittoEmail])
            composeViewController.setSubject(TextLiteral.MailHelperTitle)
            composeViewController.setMessageBody(messageBody, isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: TextLiteral.mailErrorTitle, message: TextLiteral.mailErrorMessage, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: TextLiteral.commonConfirm, style: .default)
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
