//
//  SettingViewController.swift
//  Manito
//
//  Created by 이성호 on 2022/07/02.
//

import UIKit

import SnapKit

class SettingViewController: BaseViewController {
 
    // MARK: - Property

    private let imageRow : ImageRowView = {
        let view = ImageRowView()
        return view
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func render() {
     
        view.addSubview(imageRow)
        imageRow.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    
    override func configUI() {
        super.configUI()
    }
    
    // MARK: - Selectors
    // MARK: - Functions
}
