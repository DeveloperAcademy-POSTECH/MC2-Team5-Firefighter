//
//  MemoryCollectionViewCell.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/09/19.
//

import UIKit

import SnapKit

protocol MemoryCollectionViewCellDelegate: AnyObject {
    func didTapPhotoImage(_ imageURL: String)
}

final class MemoryCollectionViewCell: UICollectionViewCell, BaseViewType {
    
    // MARK: - ui component
    
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
    
    // MARK: - property
    
    private var imageURL: String?
    
    weak var delegate: MemoryCollectionViewCellDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupImageTapGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
        self.contentLabel.text = ""
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubview(self.photoImageView)
        self.photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func configureUI() {
        self.backgroundColor = .darkGrey002
        self.makeBorderLayer(color: .white)
        self.layer.masksToBounds = true
    }
    
    // MARK: - func
    
    func setData(imageUrl: String? = nil, content: String? = nil) {
        if let imageUrl = imageUrl {
            self.photoImageView.loadImageUrl(imageUrl)
            self.imageURL = imageUrl
            return
        }
        
        if let content = content {
            self.contentLabel.text = content
            self.contentLabel.addLabelSpacing()
            self.contentLabel.textAlignment = .center
        }
    }
}

// MARK: - Helper
extension MemoryCollectionViewCell {
    private func setupImageTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapPhoto))
        self.photoImageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - selector
    
    @objc 
    private func didTapPhoto() {
        if let imageURL {
            self.delegate?.didTapPhotoImage(imageURL)
        }
    }
}
