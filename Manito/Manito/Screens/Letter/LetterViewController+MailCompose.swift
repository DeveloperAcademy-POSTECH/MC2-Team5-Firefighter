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
            let aenittoEmail = "aenitto@gmail.com"
            let messageBody = """
                              
                              -----------------------------
                              
                              - 신고자 닉네임: \(userNickname)
                              - 신고 메시지 내용:
                              \(content)
                              - 신고 날짜: \(Date())
                              
                              ------------------------------
                              
                              신고 내용을 작성해주세요.
                              
                              신고 사유:
                              """
            
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([aenittoEmail])
            composeVC.setSubject("[신고 관련 문의]")
            composeVC.setMessageBody(messageBody, isHTML: false)
            
            self.present(composeVC, animated: true)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
