//
//  LetterViewController+MailCompose.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/08/31.
//

import MessageUI

// MARK: - MFMailComposeViewControllerDelegate
extension LetterViewController: MFMailComposeViewControllerDelegate {
    func sendReportMail(userNickname: String, content: String) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            let aenittoEmail = TextLiteral.mailAenittoEmail
            let messageBody = TextLiteral.mailReportMessage(userNickname, content, Date())
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([aenittoEmail])
            composeVC.setSubject(TextLiteral.mailReportTitle)
            composeVC.setMessageBody(messageBody, isHTML: false)
            
            self.present(composeVC, animated: true)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: TextLiteral.mailErrorTitle, message: TextLiteral.mailErrorMessage, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: TextLiteral.CommonConfirm, style: .default)
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
