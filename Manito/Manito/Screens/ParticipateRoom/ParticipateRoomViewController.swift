//
//  ParticipateRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/15.
//

import UIKit

import SnapKit

final class ParticipateRoomViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.enterRoom
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        return button
    }()
    private let nextButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.searchRoom
        button.isDisabled = true
        return button
    }()    
    private let inputInvitedCodeView: InputInvitedCodeView = InputInvitedCodeView()
    
    // MARK: - property
    
    private let checkRoomInfoService: RoomProtocol = RoomAPI(apiService: APIService())
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toggleButton()
        self.setupButtonAction()
    }
    // FIXME: 플로우 연결 하면서 변경 될 예정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    // FIXME: 뒤로가기 버그 수정(PR에서 얘기후 삭제 예정)
        self.setupNotificationCenter()
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - override
    
    override func setupLayout() {
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
    
    override func setupNavigationBar() {
        // FIXME: navigation으로 변경하면서 삭제예정
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - func
    
    private func setupButtonAction() {
        let didTapCloseButton = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        
        let didTapNextButton = UIAction { [weak self] _ in
            self?.dispatchInviteCode()
        }
        
        self.closeButton.addAction(didTapCloseButton, for: .touchUpInside)
        self.nextButton.addAction(didTapNextButton, for: .touchUpInside)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveNextNotification(_:)), name: .nextNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func toggleButton() {
        self.inputInvitedCodeView.changeNextButtonEnableStatus = { [weak self] isEnable in
            self?.nextButton.isDisabled = !isEnable
        }
    }
    
    override func endEditingView() {
        if !self.nextButton.isTouchInside {
            self.view.endEditing(true)
        }
    }
    
    // MARK: - selector
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.2, animations: {
                self.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 30)
            })
        }
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.nextButton.transform = .identity
        })
    }
    
    @objc
    private func didReceiveNextNotification(_ notification: Notification) {
        guard let id = notification.userInfo?["roomId"] as? Int else { return }
        self.navigationController?.pushViewController(ChooseCharacterViewController(statusMode: .enterRoom, roomId: id), animated: true)
    }
    
    // MARK: - network
    
    private func dispatchInviteCode() {
        Task {
            do {
                guard let code = self.inputInvitedCodeView.roomCodeTextField.text else { return }
                let data = try await self.checkRoomInfoService
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
}
