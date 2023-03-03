//
//  LetterCollectionViewCell.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

import SnapKit

final class LetterCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - ui component
    
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
    private let contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .font(.regular, ofSize: 15)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    private let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private let reportButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.icReport, for: .normal)
        return button
    }()

    // MARK: - property

    var didTappedReport: (() -> ())?
    var didTappedImage: ((UIImage) -> ())?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupReportAction()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - override

    override func prepareForReuse() {
        contentLabel.text = nil
        photoImageView.image = nil
        photoImageView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
    }
    
    override func setupLayout() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14).priority(.low)
            $0.leading.equalToSuperview().inset(15)
        }
        
        contentView.addSubview(reportButton)
        reportButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(22)
        }
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(photoImageView)
        stackView.addArrangedSubview(contentLabel)
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(dateLabel.snp.top).offset(-10).priority(.required)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        photoImageView.snp.makeConstraints {
            $0.height.equalTo(0)
            $0.top.leading.trailing.equalToSuperview()
        }
    }
    
    override func configureUI() {
        clipsToBounds = true
        makeBorderLayer(color: .white.withAlphaComponent(0.5))
        setupImageTapGesture()
    }
    
    // MARK: - func
    
    private func setupReportAction() {
        let reportAction = UIAction { [weak self] _ in
            self?.didTappedReport?()
        }
        reportButton.addAction(reportAction, for: .touchUpInside)
    }
    
    func setLetterData(with data: Message, isHidden: Bool) {
        dateLabel.text = data.date
        reportButton.isHidden = isHidden
        
        if let content = data.content {
            contentLabel.text = content
            contentLabel.addLabelSpacing()
        }
        
        if let imageUrl = data.imageUrl {
            photoImageView.loadImageUrl(imageUrl)
            photoImageView.snp.updateConstraints {
                $0.height.equalTo(204)
            }
        }
    }

    func setupImageTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        photoImageView.addGestureRecognizer(tapGesture)
    }

    // MARK: - selector

    @objc
    private func didTapPhoto() {
        guard let image = photoImageView.image else { return }
        didTappedImage?(image)
    }
}
