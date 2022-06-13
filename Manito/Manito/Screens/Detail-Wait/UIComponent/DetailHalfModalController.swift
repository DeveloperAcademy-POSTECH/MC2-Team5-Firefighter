//
//  DetailHalfModalController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/13.
//

import UIKit

import SnapKit

class DetailHalfModalController: UIViewController {

    // MARK: - property

    private let cancleText: UILabel = {
        let label = UILabel()
        label.text = "취소"
        label.font = .font(.regular, ofSize: 18)
        label.textColor = .white
        return label
    }()

    private let topIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.layer.cornerRadius = 3
        return view
    }()

    private let changeText: UILabel = {
        let label = UILabel()
        label.text = "변경"
        label.font = .font(.regular, ofSize: 18)
        label.textColor = .subBlue
        return label
    }()

    private let startSettingText: UILabel = {
        let label = UILabel()
        label.text = "진행기간 설정"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        render()
    }

    func configUI() {
        view.backgroundColor = .darkGrey002
    }

    func render() {
        view.addSubview(cancleText)
        cancleText.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(29)
        }

        view.addSubview(changeText)
        changeText.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(29)
        }

        view.addSubview(topIndicator)
        topIndicator.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(6)
        }
        
        view.addSubview(startSettingText)
        startSettingText.snp.makeConstraints {
            $0.top.equalTo(cancleText.snp.bottom).offset(51)
            $0.leading.equalToSuperview().inset(16)
        }
    }
}
