//
//  ParticipateRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/15.
//

import UIKit

import SnapKit

final class ParticipateRoomViewController: BaseViewController {
    
    private let checkRoomInfoService: RoomProtocol = RoomAPI(apiService: APIService())
    
    // MARK: - property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.enterRoom
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.searchRoom
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        button.isDisabled = true
        return button
    }()
    
    private let inputInvitedCodeView = InputInvitedCodeView()
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleButton()
        setupNotificationCenter()
    }
    
    override func render() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
                
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(23)
            $0.height.equalTo(60)
        }
        
        view.addSubview(inputInvitedCodeView)
        inputInvitedCodeView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        view.bringSubviewToFront(nextButton)
    }
    
    // MARK: - API
    
    private func dispatchInviteCode() {
        Task {
            do {
                guard let code = inputInvitedCodeView.roomCodeTextField.text else { return }
                let data = try await checkRoomInfoService
                    .dispatchVerification(body: code)
                if let info = data {
                    guard let id = info.id else { return }
                    let viewController = CheckRoomViewController()
                    viewController.modalPresentationStyle = .overFullScreen
                    viewController.modalTransitionStyle = .crossDissolve
                    viewController.verification = info
                    viewController.roomId = id
                    
                    present(viewController, animated: true)
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                makeAlert(title: TextLiteral.checkRoomViewControllerErrorAlertTitle, message: TextLiteral.checkRoomViewControllerErrorAlertMessage)
                print("client Error: \(String(describing: message))")
            }
        }
    }
    
    // MARK: - func
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNextNotification(_:)), name: .nextNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func toggleButton() {
        inputInvitedCodeView.changeNextButtonEnableStatus = { [weak self] isEnable in
            self?.nextButton.isDisabled = !isEnable
        }
    }
    
    override func endEditingView() {
        if !nextButton.isTouchInside {
            view.endEditing(true)
        }
    }
    
    // MARK: - selector
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.2, animations: {
                self.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 30)
            })
        }
    }
    
    @objc private func keyboardWillHide(notification:NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.nextButton.transform = .identity
        })
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapNextButton() {
        dispatchInviteCode()
    }
    
    @objc private func didReceiveNextNotification(_ notification: Notification) {
        guard let id = notification.userInfo?["roomId"] as? Int else { return }
        self.navigationController?.pushViewController(ChooseCharacterViewController(statusMode: .enterRoom, roomId: id), animated: true)
    }
}
