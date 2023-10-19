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
    
    enum SettingActions: CaseIterable {
        case changeNickname
        case personInfomation
        case termsOfService
        case developerInfo
        case help
        case logout
        case withdrawal
        
        var title: String {
            switch self {
            case .changeNickname:
                return TextLiteral.Setting.changeNickname.localized()
            case .personInfomation:
                return TextLiteral.Setting.personalInformation.localized()
            case .termsOfService:
                return TextLiteral.Setting.termsOfService.localized()
            case .developerInfo:
                return TextLiteral.Setting.developerInfo.localized()
            case .help:
                return TextLiteral.Setting.inquiry.localized()
            case .logout:
                return TextLiteral.Setting.logout.localized()
            case .withdrawal:
                return ""
            }
        }
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
    
    private var settingActions: [SettingActions] = SettingActions.allCases

    let buttonDidTapPublisher = PassthroughSubject<SettingActions, Never>()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
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
}

extension SettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.buttonDidTapPublisher.send(self.settingActions[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension SettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingActions.count - 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewTableCell.className ,for: indexPath) as? SettingViewTableCell else {
            return UITableViewCell()
        }
        cell.configureCell(title: settingActions[indexPath.row].title)
        return cell
    }
}
