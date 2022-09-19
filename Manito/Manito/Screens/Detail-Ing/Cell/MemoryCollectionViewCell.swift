//
//  MemoryCollectionViewCell.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/09/19.
//

import UIKit

import SnapKit

final class MemoryCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - properties
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    // MARK: - life cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        contentLabel.text = ""
    }
    
    // MARK: - func
    
    override func render() {
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    override func configUI() {
        backgroundColor = .darkGrey002
        makeBorderLayer(color: .white)
        layer.masksToBounds = true
    }
    
    func setData(imageUrl: String? = nil, content: String? = nil) {
        if let imageUrl = imageUrl {
            photoImageView.loadImageUrl(imageUrl)
            return
        }
        
        if let content = content {
            contentLabel.text = content
            contentLabel.addLabelSpacing()
            contentLabel.textAlignment = .center
        }
    }
}
