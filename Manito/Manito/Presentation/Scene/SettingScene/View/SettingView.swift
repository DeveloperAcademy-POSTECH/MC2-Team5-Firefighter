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
    
    enum SettingActions {
        case changeNickname
        case personInfomation
        case termsOfService
        case developerInfo
        case help
        case logout
        case withdrawal
    }
    
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
        button.setTitle(TextLiteral.Setting.withdrawal.localized(), for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 15)
        button.setUnderLine()
        return button
    }()
    
    private let imageRow: TopCharacterImageView = TopCharacterImageView()
    
    // MARK: - property
    
    private var options: [Option] = []

    let buttonDidTapPublisher = PassthroughSubject<SettingActions, Never>()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.configureModels()
        self.setupAction()
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
            $0.width.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
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
    
    private func setupAction() {
        let didTapWithdrawalButton = UIAction { [weak self] _ in
            self?.buttonDidTapPublisher.send(.withdrawal)
        }
        self.withdrawalButton.addAction(didTapWithdrawalButton, for: .touchUpInside)
    }
    
    private func configureModels() {
        self.options.append(Option(title: TextLiteral.Setting.changeNickname.localized(), handler: { [weak self] in
            self?.buttonDidTapPublisher.send(.changeNickname)
        }))
        
        self.options.append(Option(title: TextLiteral.Setting.personalInformation.localized(), handler: { [weak self] in
            self?.buttonDidTapPublisher.send(.personInfomation)
        }))
        
        self.options.append(Option(title: TextLiteral.Setting.termsOfService.localized(), handler: { [weak self] in
            self?.buttonDidTapPublisher.send(.termsOfService)
        }))
        
        self.options.append(Option(title: TextLiteral.Setting.developerInfo.localized(), handler: { [weak self] in
            self?.buttonDidTapPublisher.send(.developerInfo)
        }))
        
        self.options.append(Option(title: TextLiteral.Setting.inquiry.localized(), handler: { [weak self] in
            self?.buttonDidTapPublisher.send(.help)
        }))
        
        self.options.append(Option(title: TextLiteral.Setting.logout.localized(), handler: { [weak self] in
            self?.buttonDidTapPublisher.send(.logout)
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
