//
//  ChooseCharacterView.swift
//  Manito
//
//  Created by 이성호 on 2023/05/10.
//

import Combine
import UIKit

import SnapKit

final class ChooseCharacterView: UIView, BaseViewType {
    
    // MARK: - ui component
    
    private let closeButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        button.setImage(UIImage.Button.xmark, for: .normal)
        return button
    }()
    private let backButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        button.setImage(UIImage.Button.back, for: .normal)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.ParticipateRoom.chooseCharacterTitle.localized()
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.ParticipateRoom.chooseCharacterSubTitle.localized()
        label.font = .font(.regular, ofSize: 18)
        label.textColor = .grey002
        return label
    }()
    let manittoCollectionView: CharacterCollectionView = CharacterCollectionView()
    private let joinButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.Common.enterRoom.localized()
        return button
    }()
    
    // MARK: - property
    
    lazy var backButtonTapPublisher = self.backButton.tapPublisher
    lazy var closeButtonTapPublisher = self.closeButton.tapPublisher
    let joinButtonTapPublisher = PassthroughSubject<Int, Never>()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupAction() {
        let didTapJoinButton = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.joinButtonTapPublisher.send(self.manittoCollectionView.characterIndexTapPublisher.value)
        }
        self.joinButton.addAction(didTapJoinButton, for: .touchUpInside)
    }
    
    func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        self.addSubview(self.subTitleLabel)
        self.subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        self.addSubview(self.joinButton)
        self.joinButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.bottom.equalToSuperview().inset(57)
            $0.height.equalTo(60)
        }
        
        self.addSubview(self.manittoCollectionView)
        self.manittoCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.bottom.equalTo(self.joinButton.snp.top)
        }
    }
    
    func configureNavigationBarItem(_ navigationController: UINavigationController) {
        let navigationItem = navigationController.topViewController?.navigationItem
        let closeButton = UIBarButtonItem(customView: self.closeButton)
        
        navigationItem?.rightBarButtonItem = closeButton
        navigationItem?.leftBarButtonItem = nil
    }

    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }
}
