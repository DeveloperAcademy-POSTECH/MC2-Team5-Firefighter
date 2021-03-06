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
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 14)
        label.textColor = .grey003
        return label
    }()
    private var contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .font(.regular, ofSize: 15)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    private var photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        contentLabel.text = nil
        photoImageView.image = nil
        photoImageView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
    }
    
    override func render() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14).priority(.low)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(photoImageView)
        stackView.addArrangedSubview(contentLabel)
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(dateLabel.snp.top).offset(-8).priority(.required)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        photoImageView.snp.makeConstraints {
            $0.height.equalTo(0)
            $0.top.leading.trailing.equalToSuperview()
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
            // FIXME: - ????????? ????????????????????? heart.fill
            photoImageView.image = UIImage(systemName: "heart.fill")
            photoImageView.snp.updateConstraints {
                $0.height.equalTo(204)
            }
        }
    }
}
