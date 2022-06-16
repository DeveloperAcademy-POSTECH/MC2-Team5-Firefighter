//
//  CheckRoomView.swift
//  Manito
//
//  Created by 이성호 on 2022/06/14.
//

import UIKit

class CheckRoomView: UIView {

    // MARK: - Property
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "명예소방관"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2022.06.06 ~ 2022.06.12"
        label.font = .font(.regular, ofSize: 22)
        return label
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    private var personLabel: UILabel = {
        let label = UILabel()
        label.text = "X 5인"
        label.font = .font(.regular, ofSize: 24)
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
    
    func render() {
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(23)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(personLabel)
        personLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(20)
            $0.top.equalTo(dateLabel.snp.bottom).offset(107)
        }
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerY.equalTo(personLabel.snp.centerY)
            $0.trailing.equalTo(personLabel.snp.leading)
            $0.width.height.equalTo(60)
        }
    }
}
