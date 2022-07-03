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
         let tabelView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    private let imageRow: ImageRowView = {
        let view = ImageRowView()
        return view
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        setupDelegate()
    }
    
    override func render() {
     
        view.addSubview(imageRow)
        imageRow.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(imageRow.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(500)
        }
    }
    
    // MARK: - Configure
    
    override func configUI() {
        super.configUI()
    }
    
    // MARK: - Selectors
    
    // MARK: - Functions
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureModels() {
        sections.append(Section(title: "닉네임 변경", options: [Option(title: "닌게임 변경하기", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.changeNickname()
            }
        })]))
        
        sections.append(Section(title: "계정 복구", options: [Option(title: "계정 복구", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.changeNickname()
            }
        })]))
    }
    
    private func changeNickname() {
        print("ss")
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
//        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" ,for: indexPath)
        return cell
    }
}
