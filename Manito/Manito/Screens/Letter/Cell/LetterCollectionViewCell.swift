//
//  LetterCollectionViewCell.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

import SnapKit

final class LetterCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - property
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 14)
        label.textColor = .darkGrey005
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 15)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(39)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.frame.size.height * 0.69)
        }
    }
    
    override func configUI() {
        clipsToBounds = true
        makeBorderLayer(color: .white.withAlphaComponent(0.5))
    }
    
    // MARK: - func
    
    func setLetterData(with data: Letter) {
        dateLabel.text = data.date
        
        if let content = data.content {
            contentLabel.text = content
            contentLabel.addLabelSpacing()
        }

        if let image = data.image {
            photoImageView.backgroundColor = .mainRed
        }
    }
}
