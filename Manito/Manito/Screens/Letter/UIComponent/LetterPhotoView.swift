//
//  LetterPhotoView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import UIKit

import SnapKit

final class LetterPhotoView: UIView {
    
    // MARK: - property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 추가"
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private let importPhotosButton: UIButton = {
        let button = UIButton()
        button.makeBorderLayer(color: .white)
        button.setImage(ImageLiterals.icCamera, for: .normal)
        return button
    }()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func
    
    private func render() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        addSubview(letterTextView)
        letterTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.height.equalTo(108)
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints {
            $0.top.equalTo(letterTextView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview()
        }
    }
}
