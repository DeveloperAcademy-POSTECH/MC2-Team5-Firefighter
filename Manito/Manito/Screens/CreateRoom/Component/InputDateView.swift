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
        label.text = TextLiteral.inputDateViewTitle
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    let calendarView = CalendarView()
    private let dateInfoLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.maxMessage
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .grey002
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
