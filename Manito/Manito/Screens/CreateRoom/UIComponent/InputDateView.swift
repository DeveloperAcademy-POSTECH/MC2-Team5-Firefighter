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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.CreateRoom.inputDateTitle.localized()
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    let calendarView: CalendarView = CalendarView()
    private let dateInfoLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.Common.Calendar.maxDateContent.localized()
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .grey002
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(self.calendarView)
        self.calendarView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(380)
        }
        
        self.calendarView.addSubview(self.dateInfoLabel)
        self.dateInfoLabel.snp.makeConstraints {
            $0.top.equalTo(self.calendarView.snp.bottom).offset(5)
            $0.trailing.equalToSuperview()
        }
    }
}
