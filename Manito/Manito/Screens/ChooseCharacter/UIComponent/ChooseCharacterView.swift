//
//  ChooseCharacterView.swift
//  Manito
//
//  Created by 이성호 on 2023/05/10.
//

import UIKit

import SnapKit

protocol ChooseCharacterViewDelegate: AnyObject {
    func backButtonDidTap()
    func closeButtonDidTap()
    func joinButtonDidTap(characterIndex: Int)
}

final class ChooseCharacterView: UIView {
    
    // MARK: - ui component
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        return button
    }()
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.icBack, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 14)
        button.tintColor = .white
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.chooseCharacterViewControllerTitleLabel
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.chooseCharacterViewControllerSubTitleLabel
        label.font = .font(.regular, ofSize: 18)
        label.textColor = .grey002
        return label
    }()
    private let manittoCollectionView: CharacterCollectionView = CharacterCollectionView()
    private lazy var joinButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.enterRoom
        return button
    }()
    
    // MARK: - property
    
    private weak var delegate: ChooseCharacterViewDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupButtonAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(66)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.addSubview(self.subTitleLabel)
        self.subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.addSubview(self.backButton)
        self.backButton.snp.makeConstraints {
            $0.top.equalTo(self.closeButton)
            $0.leading.equalToSuperview()
        }
        
        self.addSubview(self.joinButton)
        self.joinButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalToSuperview().inset(57)
            $0.height.equalTo(60)
        }
        
        self.addSubview(self.manittoCollectionView)
        self.manittoCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.joinButton.snp.top)
        }
    }
    
    private func setupButtonAction() {
        let didTapBackButton = UIAction { [weak self] _ in
            self?.delegate?.backButtonDidTap()
        }
        let didTapCloseButton = UIAction { [weak self] _ in
            self?.delegate?.closeButtonDidTap()
        }
        let didTapJoinButton = UIAction { [weak self] _ in
            self?.delegate?.joinButtonDidTap(characterIndex: self?.manittoCollectionView.characterIndex ?? 0)
        }
        
        self.backButton.addAction(didTapBackButton, for: .touchUpInside)
        self.closeButton.addAction(didTapCloseButton, for: .touchUpInside)
        self.joinButton.addAction(didTapJoinButton, for: .touchUpInside)
    }
        
    func configureDelegate(_ delegate: ChooseCharacterViewDelegate) {
        self.delegate = delegate
    }
}
