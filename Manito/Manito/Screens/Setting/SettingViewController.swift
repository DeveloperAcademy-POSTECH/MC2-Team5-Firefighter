//
//  SettingViewController.swift
//  Manito
//
//  Created by 이성호 on 2022/07/02.
//

import UIKit
import MessageUI

import SnapKit

struct Option {
    let title: String
    let handler: () -> Void
}

class SettingViewController: BaseViewController {
    
    private var options = [Option]()
    
    // MARK: - Property
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingViewTableCell.self, forCellReuseIdentifier: SettingViewTableCell.className)
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = .backgroundGrey
        return tableView
    }()
    
    private let imageRow: ImageRowView = {
        let view = ImageRowView()
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        configureModels()
        super.viewDidLoad()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func render() {
        view.addSubview(imageRow)
        imageRow.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(imageRow.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    
    override func configUI() {
        super.configUI()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()

        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Functions
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func configureModels() {
        options.append(Option(title: TextLiteral.settingViewControllerChangeNickNameTitle, handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToChangeNickname()
            }
        }))
        
        options.append(Option(title: TextLiteral.settingViewControllerPersonalInfomationTitle, handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToPersonalInfomation()
            }
        }))
        
        options.append(Option(title: TextLiteral.settingViewControllerTermsOfServiceTitle, handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToTermsOfService()
            }
        }))
        
        options.append(Option(title: TextLiteral.settingViewControllerDeveloperInfoTitle, handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToDeveloperInfo()
            }
        }))
        
        options.append(Option(title: TextLiteral.settingViewControllerHelpTitle, handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToHelp()
            }
        }))
        
        options.append(Option(title: TextLiteral.settingViewControllerLogoutTitle, handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToLogOut()
            }
        }))
    }
    
    private func goToChangeNickname() {
        navigationController?.pushViewController(ChangeNickNameViewController(), animated: true)
    }
    
    private func goToPersonalInfomation() {
        if let url = URL(string: UrlLiteral.personalInfomationUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func goToTermsOfService() {
        if let url = URL(string: UrlLiteral.termsOfServiceUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func goToDeveloperInfo() {
        navigationController?.pushViewController(SettingDeveloperInfoViewController(), animated: true)
    }
    
    private func goToHelp() {
        self.sendReportMail()
    }
    
    private func goToLogOut() {
        UserDefaultHandler.clearAllData()
        let viewController = LoginViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }
}


// MARK: - Extensions

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = options[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewTableCell.className ,for: indexPath) as? SettingViewTableCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = model.title
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    func sendReportMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            let aenittoEmail = "aenitto@gmail.com"
            let messageBody = """
                              
                              -----------------------------
                              
                              - 문의하는 닉네임:
                              - 문의 메시지 제목 한줄 요약:
                              - 문의 날짜: \(Date())
                              
                              ------------------------------
                              
                              문의 내용을 작성해주세요.
                              
                              """
            
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([aenittoEmail])
            composeVC.setSubject("[문의 사항]")
            composeVC.setMessageBody(messageBody, isHTML: false)
            
            self.present(composeVC, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
