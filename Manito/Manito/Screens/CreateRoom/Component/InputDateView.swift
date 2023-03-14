//
//  InputDateView.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/11.
//

import UIKit

import SnapKit

final class InputDateView: UIView {
    
    // MARK: - ui component
    
    private let dateViewLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.inputDateViewTitle
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    let calendarView: CalendarView = CalendarView()
    private let dateInfoLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.maxMessage
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .grey002
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setLayout() {
        self.addSubview(dateViewLabel)
        self.dateViewLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(calendarView)
        self.calendarView.snp.makeConstraints {
            $0.top.equalTo(dateViewLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(380)
        }
        
        self.calendarView.addSubview(dateInfoLabel)
        self.dateInfoLabel.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(5)
            $0.trailing.equalToSuperview()
        }
    }
}
