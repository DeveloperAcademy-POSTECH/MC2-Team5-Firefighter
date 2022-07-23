//
//  SettingViewController.swift
//  Manito
//
//  Created by 이성호 on 2022/07/02.
//

import UIKit

import SnapKit

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}

class SettingViewController: BaseViewController {
 
    private var sections = [Section]()
    
    // MARK: - Property
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingViewTableCell.self, forCellReuseIdentifier: SettingViewTableCell.identifier)
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
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
    
    override func render() {
     
        view.addSubview(imageRow)
        imageRow.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(imageRow.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(sections.count*70)
        }
    }
    
    // MARK: - Configure
    
    override func configUI() {
        super.configUI()
    }
    
    // MARK: - Functions
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureModels() {
        sections.append(Section(title: "닉네임 변경", options: [Option(title: "닉네임 변경하기", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToChangeNickname()
            }
        })]))
        
        sections.append(Section(title: "계정 복구", options: [Option(title: "개인정보 처리방침", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToPersonalInfomation()
            }
        })]))
        
        sections.append(Section(title: "이용 약관", options: [Option(title: "이용 약관", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToTermsOfService()
            }
        })]))
        
        sections.append(Section(title: "개발자 정보", options: [Option(title: "개발자 정보", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToDeveloperInfo()
            }
        })]))
        
        sections.append(Section(title: "문의하기", options: [Option(title: "문의하기", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToHelp()
            }
        })]))
        
        sections.append(Section(title: "로그아웃", options: [Option(title: "로그아웃", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToLogOut()
            }
        })]))
    }
    
    private func goToChangeNickname() {
        print("goToChangeNickname")
    }
    
    private func goToPersonalInfomation() {
        print("goToPersonalInfomation")
    }
    
    private func goToTermsOfService() {
        print("goToTermsOfService")
    }
    
    private func goToDeveloperInfo() {
        print("goToDeveloperInfo")
    }
    
    private func goToHelp() {
        print("goToHelp")
    }
    
    private func goToLogOut() {
        print("goToLogOut")
    }
}


// MARK: - Extensions

extension SettingViewController: UITableViewDelegate {
    
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewTableCell.identifier ,for: indexPath) as! SettingViewTableCell
        cell.titleLabel.text = model.title
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
