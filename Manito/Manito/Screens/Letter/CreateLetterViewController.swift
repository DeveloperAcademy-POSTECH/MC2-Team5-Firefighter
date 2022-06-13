//
//  CreateLetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import UIKit

import SnapKit

final class CreateLetterViewController: BaseViewController {

    
    // MARK: - property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "쪽지 작성하기"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let missionView = IndividualMissionView(mission: "1000원 이하의 선물 주고 인증샷 받기")
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func render() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(59)
            $0.leading.equalToSuperview().inset(23)
        }
        
        view.addSubview(missionView)
        missionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
    }
}
