//
//  MemoryCollectionViewCell.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/09/19.
//

import UIKit

import SnapKit

final class MemoryCollectionViewCell: UICollectionViewCell, BaseViewType {
    var didTappedImage: ((UIImage) -> ())?
    
    // MARK: - properties
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        contentLabel.text = ""
    }
    
    // MARK: - base func
    
    func setupLayout() {
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func configureUI() {
        backgroundColor = .darkGrey002
        makeBorderLayer(color: .white)
        layer.masksToBounds = true
        setupImageTapGesture()
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
    
    private func setupImageTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        photoImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapPhoto() {
        guard let image = photoImageView.image else { return }
        didTappedImage?(image)
    }
}
