//
//  DetailWaitViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit
import SnapKit

class DetailWaitViewController: BaseViewController {
    private let roomTitle: UILabel = {
        let label = UILabel()
        label.text = "명예소방관"
        label.textColor = .white
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 34)
        return label
    }()

    private let startStauts: UILabel = {
        let label = UILabel()
        // MARK: enum으로 만드는게 좋아보임
        label.text = "대기중"
        label.backgroundColor = .waitBackgroundColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11
        label.textColor = .waitTextColor
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 13)
        label.textAlignment = .center
        return label
    }()

    private lazy var durationView: UIView = {
        let durationView = UIView()
        durationView.backgroundColor = .durationBackgroundColor
        durationView.layer.cornerRadius = 8
        durationView.addSubview(durationText)
        durationView.addSubview(durationDateText)
        return durationView
    }()

    private let durationText: UILabel = {
        let durationText = UILabel()
        durationText.text = "진행 기간"
        durationText.textColor = .grey4
        durationText.font = UIFont(name: AppFontName.regular.rawValue, size: 14)
        return durationText
    }()
    
    private let durationDateText: UILabel = {
        let dateText = UILabel()
        dateText.text = "22.06.06 ~ 22.06.10"
        dateText.textColor = .white
        dateText.font = UIFont(name: AppFontName.regular.rawValue, size: 18)
        return dateText
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor
        render()
        // Do any additional setup after loading the view.
    }

    override func render() {
        view.addSubview(roomTitle)
        roomTitle.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
        }

        view.addSubview(startStauts)
        startStauts.snp.makeConstraints {
            $0.centerY.equalTo(roomTitle.snp.centerY)
            $0.left.equalTo(roomTitle.snp.right).offset(10)
            $0.width.equalTo(66)
            $0.height.equalTo(23)
        }
        
        view.addSubview(durationView)
        durationView.snp.makeConstraints {
            $0.top.equalTo(roomTitle.snp.bottom).offset(30)
            $0.trailing.leading.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
        
        durationText.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        durationDateText.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(40)
            $0.centerY.equalToSuperview()
        }
    }
}
