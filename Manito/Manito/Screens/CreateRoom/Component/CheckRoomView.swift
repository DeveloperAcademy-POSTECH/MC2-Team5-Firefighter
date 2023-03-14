//
//  CheckRoomView.swift
//  Manito
//
//  Created by 이성호 on 2022/06/14.
//

import UIKit

import SnapKit

final class CheckRoomView: UIView {

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
    
    var dateRange = "" {
        willSet {
            dateLabel.text = newValue
        }
    }
    var name: String = "" {
        willSet {
            nameLabel.text = newValue
        }
    }
    var person: Int = 0 {
        willSet {
            personLabel.text = "\(newValue.description)" + TextLiteral.per
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setLayout() {
        self.addSubview(nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(dateLabel)
        self.dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(23)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(personLabel)
        self.personLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(20)
            $0.top.equalTo(dateLabel.snp.bottom).offset(107)
        }
        
        self.addSubview(imageView)
        self.imageView.snp.makeConstraints {
            $0.centerY.equalTo(personLabel.snp.centerY)
            $0.trailing.equalTo(personLabel.snp.leading)
            $0.width.height.equalTo(60)
        }
    }
}
