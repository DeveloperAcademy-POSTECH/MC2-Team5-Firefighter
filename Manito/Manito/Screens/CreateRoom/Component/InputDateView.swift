//
//  InputDateView.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/11.
//

import UIKit

import SnapKit

class InputDateView: UIView {
    
    // MARK: - Property
    
    private let dateViewLabel: UILabel = {
        let label = UILabel()
        label.text = "활동 기간을 설정해 주세요"
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    private let calendarView = CalendarView()
    private let dateInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 7일까지 설정할 수 있어요 !"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .grey002
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        tapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Funtion
    
    private func tapGesture() {
        let gestureTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapDateBackView(_:)))
        gestureTapRecognizer.numberOfTapsRequired = 1
        gestureTapRecognizer.numberOfTouchesRequired = 1
        self.addGestureRecognizer(gestureTapRecognizer)
    }
    
    // MARK: - Selector
    
    @objc private func didTapDateBackView(_ gesture: UITapGestureRecognizer) {
        print("gesture")
    }
    
    // MARK: - Config
    
    private func render() {
        self.addSubview(dateViewLabel)
        dateViewLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(dateViewLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(380)
        }
        
        calendarView.addSubview(dateInfoLabel)
        dateInfoLabel.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(5)
            $0.trailing.equalToSuperview()
        }
    }
}
