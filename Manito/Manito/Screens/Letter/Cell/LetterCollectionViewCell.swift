//
//  LetterCollectionViewCell.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

import SnapKit

protocol LetterCollectionViewCellDelegate: AnyObject {
    func didTapReportButton(content: String)
    func didTapLetterImageView(imageURL: String)
}

final class LetterCollectionViewCell: BaseCollectionViewCell {
    
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

    private var imageURL: String?
    private weak var delegate: LetterCollectionViewCellDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButtonAction()
        self.setupImageTapGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
    
    private func setupButtonAction() {
        let reportAction = UIAction { [weak self] _ in
            let content = self?.contentLabel.text ?? "글 내용 없음"
            self?.delegate?.didTapReportButton(content: content)
        }
        self.reportButton.addAction(reportAction, for: .touchUpInside)
    }

    private func setupImageTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapLetterImageView))
        self.photoImageView.addGestureRecognizer(tapGesture)
    }

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

    func configureDelegation(_ delegate: LetterCollectionViewCellDelegate) {
        self.delegate = delegate
    }

    func configure(mission: String?,
                   date: String,
                   content: String?,
                   imageURL: String?,
                   isTodayLetter: Bool,
                   canReport: Bool) {
        if let mission {
            self.missionLabel.text = mission
            self.missionLabel.snp.updateConstraints {
                $0.bottom.equalTo(self.contentLabel.snp.top).offset(20)
            }
        } else {
            self.missionLabel.text = date
            self.missionLabel.snp.updateConstraints {
                $0.bottom.equalTo(self.contentLabel.snp.top).offset(5)
            }
        }

        if let content {
            self.contentLabel.text = content
            self.contentLabel.addLabelSpacing()
        }
        
        if let imageURL {
            self.imageURL = imageURL
            self.photoImageView.loadImageUrl(imageURL)
            self.photoImageView.snp.updateConstraints {
                $0.height.equalTo(204)
            }
        }

        self.missionLabel.textColor = isTodayLetter ? .subOrange : .grey003
        self.reportButton.isHidden = !canReport
    }

    // MARK: - selector

    @objc
    private func didTapLetterImageView() {
        guard let imageURL else { return }
        self.delegate?.didTapLetterImageView(imageURL: imageURL)
    }
}
