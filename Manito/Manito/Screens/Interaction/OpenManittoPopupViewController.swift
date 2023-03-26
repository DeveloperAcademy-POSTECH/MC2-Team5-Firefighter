//
//  OpenManittoPopupViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/19.
//

import UIKit

import SnapKit

final class OpenManittoPopupViewController: BaseViewController {

    // MARK: - ui component
    
    private let popupImageView = UIImageView(image: ImageLiterals.imgEnterRoom)
    private let typingLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 24)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 18)
        label.text = TextLiteral.openManittoPopupViewControllerInformationText
        label.numberOfLines = 2
        label.addLabelSpacing()
        label.textAlignment = .center
        label.makeShadow(color: .black,
                         opacity: 0.5,
                         offset: CGSize(width: 0, height: 3),
                         radius: 3)
        return label
    }()
    private let confirmButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.confirm
        return button
    }()

    // MARK: - property
    
    private let userNickname = UserDefaultStorage.nickname ?? "당신"
    var manittoNickname: String = "디너"
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTypingAnimation()
    }
    
    override func setupLayout() {
        view.addSubview(popupImageView)
        popupImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(UIScreen.main.bounds.size.height * 0.15)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(popupImageView.snp.width).multipliedBy(1.16)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(31)
            $0.centerX.equalToSuperview()
        }
        
        popupImageView.addSubview(typingLabel)
        typingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-30)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        popupImageView.addSubview(informationLabel)
        informationLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(51)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func configureUI() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    // MARK: - func

    private func setupButtonAction() {
        let action = UIAction { [weak self] _ in
            guard let parentViewController = self?.presentingViewController else { return }
            self?.dismiss(animated: true, completion: {
                parentViewController.dismiss(animated: true)
            })
        }
        self.confirmButton.addAction(action, for: .touchUpInside)
    }
    
    private func setTypingAnimation() {
        typingLabel.setTyping(text: "\(userNickname)의 마니또는\n\(manittoNickname)입니다.")
        typingLabel.addLabelSpacing()
    }
}
