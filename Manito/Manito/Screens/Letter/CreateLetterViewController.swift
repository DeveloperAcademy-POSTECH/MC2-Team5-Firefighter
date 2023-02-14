//
//  CreateLetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import UIKit

import SnapKit

final class CreateLetterViewController: BaseViewController {
    
    var createLetter: (() -> ())?
    
    // MARK: - ui component
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.layer.cornerRadius = 2
        return view
    }()
    private let cancelButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        button.setTitle(TextLiteral.cancel, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        return button
    }()
    private let sendButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 44)))
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        button.setTitle("보내기", for: .normal)
        button.setTitleColor(.subBlue, for: .normal)
        button.setTitleColor(.subBlue.withAlphaComponent(0.5), for: .highlighted)
        button.setTitleColor(.subBlue.withAlphaComponent(0.5), for: .disabled)
        return button
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private let scrollContentView = UIView()
    private let letterTextView = CreateLetterTextView()
    private let letterPhotoView = LetterPhotoView()
    private lazy var missionView = IndividualMissionView(mission: self.mission)

    // MARK: - property
    
    private let letterSevice: LetterAPI = LetterAPI(apiService: APIService())
    var manitteeId: String
    var roomId: String
    var mission: String
    
    // MARK: - init
    
    init(manitteeId: String, roomId: String, mission: String) {
        self.manitteeId = manitteeId
        self.roomId = roomId
        self.mission = mission
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkSendButtonEnabled()
        self.setupNavigationItem()
        self.setupButtonAction()
    }

    // MARK: - override
    
    override func setupLayout() {
        self.view.addSubview(self.indicatorView)
        self.indicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(3)
            $0.width.equalTo(40)
        }
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.scrollView.addSubview(self.scrollContentView)
        self.scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(self.scrollView.snp.width)
        }
        
        self.scrollContentView.addSubview(self.missionView)
        self.missionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(100)
        }
        
        self.scrollContentView.addSubview(self.letterTextView)
        self.letterTextView.snp.makeConstraints {
            $0.top.equalTo(self.missionView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.scrollContentView.addSubview(self.letterPhotoView)
        self.letterPhotoView.snp.makeConstraints {
            $0.top.equalTo(self.letterTextView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalToSuperview().inset(105)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        self.navigationController?.presentationController?.delegate = self
        self.isModalInPresentation = true
    }
    
    override func setupNavigationBar() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        let font = UIFont.font(.regular, ofSize: 16)
        
        appearance.titleTextAttributes = [.font: font]
        appearance.shadowColor = .clear
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundImage = nil
        appearance.shadowImage = nil
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        self.title = TextLiteral.createLetterViewControllerTitle
    }
    
    // MARK: - func
    
    private func checkSendButtonEnabled() {
        self.letterTextView.applySendButtonEnabled = { [weak self] in
            self?.changeButtonEnabledState()
        }
        self.letterPhotoView.applySendButtonEnabled = { [weak self] in
            self?.changeButtonEnabledState()
        }
    }
    
    private func changeButtonEnabledState() {
        let hasText = self.letterTextView.hasText
        let hasImage = self.letterPhotoView.importPhotosButton.imageView?.image != ImageLiterals.btnCamera
        let canEnabled = hasText || hasImage
        
        self.sendButton.isEnabled = canEnabled
    }
    
    private func setupNavigationItem() {
        let cancelButton = self.makeBarButtonItem(with: cancelButton)
        let sendButton = self.makeBarButtonItem(with: sendButton)
        
        sendButton.isEnabled = false
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = sendButton
    }
    
    private func setupButtonAction() {
        let cancelAction = UIAction { [weak self] _ in
            self?.presentationControllerDidAttemptToDismissAction()
        }
        let sendAction = UIAction { [weak self] _ in
            guard let roomId = self?.roomId else { return }

            self?.dispatchLetter(roomId: roomId)
            self?.dismiss(animated: true)
        }
        
        self.cancelButton.addAction(cancelAction, for: .touchUpInside)
        self.sendButton.addAction(sendAction, for: .touchUpInside)
    }
    
    private func presentationControllerDidAttemptToDismissAction() {
        let hasText = self.letterTextView.hasText
        let hasImage = self.letterPhotoView.importPhotosButton.imageView?.image != ImageLiterals.btnCamera
        guard hasText || hasImage else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.presentActionSheet()
    }
    
    private func presentActionSheet() {
        let dismissAction: ((UIAlertAction) -> ()) = { [weak self] _ in
            self?.resignFirstResponder()
            self?.dismiss(animated: true, completion: nil)
        }
        self.makeActionSheet(actionTitles: [TextLiteral.destructive, TextLiteral.cancel],
                             actionStyle: [.destructive, .cancel],
                             actions: [dismissAction, nil])
    }
    
    // MARK: - network
    
    private func dispatchLetter(roomId: String) {
        Task {
            do {
                if let content = self.letterTextView.text,
                   let image = self.letterPhotoView.importPhotosButton.imageView?.image,
                   image != ImageLiterals.btnCamera {
                    guard let jpegData = image.jpegData(compressionQuality: 0.3) else { return }
                    let dto = LetterDTO(manitteeId: self.manitteeId, messageContent: content)
                    
                    let status = try await self.letterSevice.dispatchLetter(roomId: roomId, image: jpegData, letter: dto)

                    if status == 201 {
                        self.createLetter?()
                    }
                } else if let content = self.letterTextView.text {
                    let dto = LetterDTO(manitteeId: self.manitteeId, messageContent: content)
                    
                    let status = try await self.letterSevice.dispatchLetter(roomId: roomId, letter: dto)

                    if status == 201 {
                        self.createLetter?()
                    }
                } else if let image = self.letterPhotoView.importPhotosButton.imageView?.image,
                          image != ImageLiterals.btnCamera {
                    guard let jpegData = image.jpegData(compressionQuality: 0.3) else { return }
                    let dto = LetterDTO(manitteeId: self.manitteeId)

                    let status = try await self.letterSevice.dispatchLetter(roomId: roomId, image: jpegData, letter: dto)
                    
                    if status == 201 {
                        self.createLetter?()
                    }
                }
                
            } catch NetworkError.serverError {
                print("serverError")
            } catch NetworkError.clientError(let message) {
                print("clientError:\(String(describing: message))")
            }
        }
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension CreateLetterViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.presentationControllerDidAttemptToDismissAction()
    }
}
