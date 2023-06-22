//
//  LetterCollectionViewCell.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import Combine
import UIKit

import SnapKit

final class LetterCollectionViewCell: BaseCollectionViewCell {

    typealias ConfigurationData = (mission: String?, date: String, content: String?, imageURL: String?, isTodayLetter: Bool, canReport: Bool?)

    private enum ConstantSize {
        static let contentSpacing: CGFloat = 10
        static let wholeSpacing: CGFloat = 14
        static let bottomInset: CGFloat = 22
        static let imageHeight: CGFloat = 204
    }
    
    // MARK: - ui component
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = ConstantSize.contentSpacing
        stackView.layoutMargins = UIEdgeInsets(top: ConstantSize.wholeSpacing, left: 11, bottom: 0, right: 11)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let wholeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        return stackView
    }()
    private let missionLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 14)
        label.numberOfLines = 0
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

    var reportButtonTapPublisher: AnyPublisher<Void, Never> {
        return self.reportButton.tapPublisher
    }

    var imageViewTapGesturePublisher: PassthroughSubject<Void, Never> = PassthroughSubject()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImageGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - override
    
    override func setupLayout() {
        self.contentView.addSubview(self.wholeStackView)
        self.wholeStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(ConstantSize.bottomInset)
        }

        self.wholeStackView.addArrangedSubview(self.photoImageView)
        self.wholeStackView.addArrangedSubview(self.contentStackView)
        self.photoImageView.snp.makeConstraints {
            $0.height.equalTo(ConstantSize.imageHeight)
        }

        self.contentStackView.addArrangedSubview(self.missionLabel)
        self.contentStackView.addArrangedSubview(self.contentLabel)

        self.contentView.addSubview(self.reportButton)
        self.reportButton.snp.makeConstraints {
            $0.top.equalTo(self.missionLabel.snp.top)
            $0.trailing.equalToSuperview().inset(11)
            $0.width.height.equalTo(22)
        }
    }
    
    override func configureUI() {
        self.clipsToBounds = true
        self.makeBorderLayer(color: .white.withAlphaComponent(0.5))
    }
    
    // MARK: - func

    private func setupImageGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapImage))
        self.photoImageView.addGestureRecognizer(tapGesture)
    }

    // MARK: - selector

    @objc
    private func didTapImage() {
        self.imageViewTapGesturePublisher.send(())
    }
}

// MARK: - Public - func
extension LetterCollectionViewCell {
    func configureCell(_ data: ConfigurationData) {
        if let mission = data.mission {
            self.missionLabel.text = mission
        } else {
            self.missionLabel.text = data.date
        }

        if let content = data.content {
            self.contentLabel.text = content
            self.contentLabel.addLabelSpacing()
            self.contentLabel.isHidden = false
        } else {
            contentLabel.isHidden = true
        }

        if let imageURL = data.imageURL {
            self.photoImageView.isHidden = false
            self.photoImageView.loadImageUrl(imageURL)
        } else {
            self.photoImageView.isHidden = true
        }

        self.missionLabel.textColor = data.isTodayLetter ? .subOrange : .grey003
        self.reportButton.isHidden = !(data.canReport ?? false)
    }
}
