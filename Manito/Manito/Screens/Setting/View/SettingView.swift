//
//  SettingView.swift
//  Manito
//
//  Created by 이성호 on 2023/05/12.
//

import Combine
import UIKit

import SnapKit

protocol SettingViewDelegate: AnyObject {
    func changNicknameButtonDidTap()
    func personalInfomationButtonDidTap()
    func termsOfServiceButtonDidTap()
    func developerInfoButtonDidTap()
    func helpButtonDidTap()
    func logoutButtonDidTap()
    func withdrawalButtonDidTap()
}

final class SettingView: UIView {
    
    struct Option {
        let title: String
        let handler: () -> Void
    }
    
    // MARK: - ui component
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingViewTableCell.self, forCellReuseIdentifier: SettingViewTableCell.className)
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = .backgroundGrey
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    private let withdrawalButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextLiteral.settingViewControllerWithdrawalTitle, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 15)
        button.setUnderLine()
        return button
    }()
    
    private let imageRow: ImageRowView = ImageRowView()
    
    // MARK: - property
    
    private var options: [Option] = []
    private weak var delegate: SettingViewDelegate?
    
    let withdrawalButtonPublisher = PassthroughSubject<Void, Never>()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupButtonAction()
        self.configureModels()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.imageRow)
        self.imageRow.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.imageRow.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        self.addSubview(self.withdrawalButton)
        self.withdrawalButton.snp.makeConstraints {
            $0.top.equalTo(self.tableView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupButtonAction() {
        let withdrawalButtonDidTap = UIAction { [weak self] _ in
            self?.delegate?.withdrawalButtonDidTap()
        }
        
        self.withdrawalButton.addAction(withdrawalButtonDidTap, for: .touchUpInside)
    }
    
    private func configureModels() {
        self.options.append(Option(title: TextLiteral.settingViewControllerChangeNickNameTitle, handler: { [weak self] in
            self?.delegate?.changNicknameButtonDidTap()
        }))
        
        self.options.append(Option(title: TextLiteral.settingViewControllerPersonalInfomationTitle, handler: { [weak self] in
            self?.delegate?.personalInfomationButtonDidTap()
        }))
        
        self.options.append(Option(title: TextLiteral.settingViewControllerTermsOfServiceTitle, handler: { [weak self] in
            self?.delegate?.termsOfServiceButtonDidTap()
        }))
        
        self.options.append(Option(title: TextLiteral.settingViewControllerDeveloperInfoTitle, handler: { [weak self] in
            self?.delegate?.developerInfoButtonDidTap()
        }))
        
        self.options.append(Option(title: TextLiteral.settingViewControllerHelpTitle, handler: { [weak self] in
            self?.delegate?.helpButtonDidTap()
        }))
        
        self.options.append(Option(title: TextLiteral.settingViewControllerLogoutTitle, handler: { [weak self] in
            self?.delegate?.logoutButtonDidTap()
        }))
    }
    
    func configureDelegate(_ delegate: SettingViewDelegate) {
        self.delegate = delegate
    }
}

extension SettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.options[indexPath.row]
        model.handler()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension SettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.options[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewTableCell.className ,for: indexPath) as? SettingViewTableCell else {
            return UITableViewCell()
        }
        cell.configureCell(title: model.title)
        return cell
    }
}
