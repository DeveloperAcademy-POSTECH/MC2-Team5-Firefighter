//
//  ParticipateRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/15.
//

import UIKit

import SnapKit

class ParticipateRoomViewController: BaseViewController {
    
    // MARK: - Property
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "방 참가하기"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: MainButton = {
        let button = MainButton()
        button.title = "방 입장"
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private let inputInvitedCodeView = InputInvitedCodeView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func render() {
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.width.height.equalTo(44)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(57)
            $0.height.equalTo(60)
        }
        
        view.addSubview(inputInvitedCodeView)
        inputInvitedCodeView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }
    
    // MARK: - Configure
    override func configUI() {
        super.configUI()
        view.backgroundColor = .backgroundGrey
    }
    
    // MARK: - Selectors
    @objc func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapNextButton() {
        let storyboard = UIStoryboard(name: "CheckRoom", bundle: nil)
        let CheckRoomVC = storyboard.instantiateViewController(identifier: "CheckRoomViewController")
        
        CheckRoomVC.modalPresentationStyle = .overFullScreen
        CheckRoomVC.modalTransitionStyle = .crossDissolve
        
        present(CheckRoomVC, animated: true, completion: nil)
    }
}
