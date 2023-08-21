//
//  CheckRoomView.swift
//  Manito
//
//  Created by 이성호 on 2022/06/14.
//

import UIKit

import SnapKit

final class CheckRoomInfoView: UIView {

    // MARK: - ui component
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .font(.regular, ofSize: 22)
        return label
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.imgNi
        return imageView
    }()
    private var personLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .font(.regular, ofSize: 24)
        return label
    }()
    
    // MARK: - property
    
    private var dateRange = "" {
        willSet {
            self.dateLabel.text = newValue
        }
    }
    private var title: String = "" {
        willSet {
            self.nameLabel.text = newValue
        }
    }
    private var capacity: Int = 0 {
        willSet {
            self.personLabel.text = "\(newValue.description)" + TextLiteral.per
        }
    }
    
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
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints {
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(23)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(self.personLabel)
        self.personLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(20)
            $0.top.equalTo(self.dateLabel.snp.bottom).offset(107)
        }
        
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints {
            $0.centerY.equalTo(self.personLabel.snp.centerY)
            $0.trailing.equalTo(self.personLabel.snp.leading)
            $0.width.height.equalTo(60)
        }
    }
    
    func updateRoomTitle(title: String) {
        self.title = title
    }
    
    func roomTitle() -> String {
        return self.title
    }
    
    func updateRoomCapacity(capacity: Int) {
        self.capacity = capacity
    }
    
    func roomCapacity() -> Int {
        return self.capacity
    }
    
    func updateRoomDateRange(range: String) {
        self.dateRange = range
    }
}
