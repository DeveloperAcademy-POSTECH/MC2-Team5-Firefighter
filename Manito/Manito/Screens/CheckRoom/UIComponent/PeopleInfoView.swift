//
//  PeopleInfoView.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/16.
//

import UIKit

import SnapKit

final class PeopleInfoView: UIView {
    
    // MARK: - property
    
    private let peopleImageView = UIImageView(image: ImageLiterals.imgNi)    
    let peopleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 24)
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
    
    // MARK: - life cycle
    
    private func setupLayout() {
        self.addSubview(self.peopleImageView)
        self.peopleImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        self.addSubview(self.peopleLabel)
        self.peopleLabel.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            $0.leading.equalTo(self.peopleImageView.snp.trailing).offset(5)
        }
    }
}
