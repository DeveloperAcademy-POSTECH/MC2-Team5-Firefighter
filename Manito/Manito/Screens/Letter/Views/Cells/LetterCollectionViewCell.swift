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
    
    // MARK: - ui component
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 25
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

    var imageViewTapGesturePublisher: AnyPublisher<Void, Never> {
        return self.photoImageView.tapGesturePublisher
    }

    private var imageURL: String?

    // MARK: - override

    override func prepareForReuse() {
        self.initializeConfiguration()
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.photoImageView)
        self.stackView.addArrangedSubview(self.contentLabel)
        self.stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(11)
        }
        
        self.photoImageView.snp.makeConstraints {
            $0.height.equalTo(0)
            $0.top.leading.trailing.equalToSuperview()
        }

        self.contentView.addSubview(self.missionLabel)
        self.missionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(11)
            $0.bottom.equalTo(self.contentLabel.snp.top).offset(5)
        }

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

    private func initializeConfiguration() {
        self.missionLabel.text = nil
        self.contentLabel.text = nil
        self.photoImageView.image = nil
        self.missionLabel.snp.updateConstraints {
            $0.bottom.equalTo(self.contentLabel.snp.top).offset(5)
        }
        self.photoImageView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
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
        }

        if let imageURL = data.imageURL {
            self.imageURL = imageURL
            self.photoImageView.loadImageUrl(imageURL)
        }

        self.missionLabel.textColor = data.isTodayLetter ? .subOrange : .grey003
        self.reportButton.isHidden = !(data.canReport ?? false)
    }
}
