//
//  SettingView.swift
//  Manito
//
//  Created by 이성호 on 2023/05/12.
//

import Combine
import UIKit

import SnapKit

final class SettingView: UIView, BaseViewType {
    
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
    
    private let imageRow: TopCharacterImageView = TopCharacterImageView()
    
    // MARK: - property
    
    private var options: [Option] = []
    
    let changNicknameButtonDidTapPublisher = PassthroughSubject<Void, Never>()
    let personalInfomationButtonDidTapPublisher = PassthroughSubject<Void, Never>()
    let termsOfServiceButtonDidTapPublisher = PassthroughSubject<Void, Never>()
    let developerInfoButtonDidTapPublisher = PassthroughSubject<Void, Never>()
    let helpButtonDidTapPublisher = PassthroughSubject<Void, Never>()
    let logoutButtonPublisher = PassthroughSubject<Void, Never>()
    lazy var withdrawalButtonPublisher = self.withdrawalButton.tapPublisher
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.configureModels()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
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

    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }

    // MARK: - func
    
    private func configureModels() {
        self.options.append(Option(title: TextLiteral.settingViewControllerChangeNickNameTitle, handler: { [weak self] in
            self?.changNicknameButtonDidTapPublisher.send()
        }))
        
        self.options.append(Option(title: TextLiteral.settingViewControllerPersonalInfomationTitle, handler: { [weak self] in
            self?.personalInfomationButtonDidTapPublisher.send()
        }))
        
        self.options.append(Option(title: TextLiteral.settingViewControllerTermsOfServiceTitle, handler: { [weak self] in
            self?.termsOfServiceButtonDidTapPublisher.send()
        }))
        
        self.options.append(Option(title: TextLiteral.settingViewControllerDeveloperInfoTitle, handler: { [weak self] in
            self?.developerInfoButtonDidTapPublisher.send()
        }))
        
        self.options.append(Option(title: TextLiteral.settingViewControllerHelpTitle, handler: { [weak self] in
            self?.helpButtonDidTapPublisher.send()
        }))
        
        self.options.append(Option(title: TextLiteral.settingViewControllerLogoutTitle, handler: { [weak self] in
            self?.logoutButtonPublisher.send()
        }))
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
