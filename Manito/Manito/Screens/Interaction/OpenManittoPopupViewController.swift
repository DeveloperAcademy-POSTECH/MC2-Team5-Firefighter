//
//  OpenManittoPopupViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/19.
//

import UIKit

import SnapKit

final class OpenManittoPopupViewController: BaseViewController {

    // MARK: - property
    
    private let popupView = UIImageView(image: ImageLiterals.imgEnterRoom)
    private lazy var typingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .font(.regular, ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    private let openMentLabel: UILabel = {
        let label = UILabel()
        label.text = """
        함께 했던 추억이 열렸습니다.
        마니또 방에서 확인해보세요!
        """
        label.numberOfLines = 2
        label.font = .font(.regular, ofSize: 18)
        label.addLabelSpacing()
        label.textAlignment = .center
        label.makeShadow(color: .black,
                         opacity: 0.5,
                         offset: CGSize(width: 0, height: 3),
                         radius: 3)
        return label
    }()
    private let confirmButton: UIButton = {
        let button = MainButton()
        button.title = "확인"
        return button
    }()
    var manittoText: String = "디너"
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTypingAnimation()
    }
    
    override func render() {
        view.addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(UIScreen.main.bounds.size.height * 0.15)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(popupView.snp.width).multipliedBy(1.16)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(31)
            $0.centerX.equalToSuperview()
        }
        
        popupView.addSubview(typingLabel)
        typingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(popupView.frame.height * 0.36)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        popupView.addSubview(openMentLabel)
        openMentLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(51)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func configUI() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    // MARK: - func
    
    private func setTypingAnimation() {
        typingLabel.setTyping(text: "호야의 마니또는\n\(manittoText) 입니다.")
        typingLabel.addLabelSpacing()
    }
}
