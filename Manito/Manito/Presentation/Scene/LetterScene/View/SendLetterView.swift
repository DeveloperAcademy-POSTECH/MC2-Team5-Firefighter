//
//  SendLetterView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/24.
//

import UIKit

import SnapKit

final class SendLetterView: UIView, BaseViewType {

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
        button.setTitle(TextLiteral.createLetterViewControllerSendButton, for: .normal)
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
    private let scrollContentView: UIView = UIView()
    private let missionView: IndividualMissionView = IndividualMissionView()
    private let letterTextView: CreateLetterTextView = CreateLetterTextView()
    private let letterPhotoView: CreateLetterPhotoView = CreateLetterPhotoView()

    // MARK: - property

//    private var sendButtonObserver: (hasText: Bool, hasImage: Bool) = (false, false) {
//        willSet {
//            self.sendButton.isEnabled = newValue.hasText || newValue.hasImage
//        }
//    }
//
//    var sending: Bool = false {
//        willSet(isDisabled) {
//            self.sendButton.isEnabled = !isDisabled
//        }
//    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func

    func configureNavigationController(of viewController: UIViewController) {
        self.setupNavigationController(of: viewController)
        self.setupNavigationItem(in: viewController.navigationController ?? UINavigationController())
    }

    func setupMission(to mission: String) {
        self.missionView.setupMission(to: mission)
    }

    // FIXME: - Stream으로 변경
//    private func setupButtonAction() {
//        let cancelAction = UIAction { [weak self] _ in
//            self?.presentationControllerDidAttemptToDismiss()
//        }
//        self.cancelButton.addAction(cancelAction, for: .touchUpInside)
//
//        let sendAction = UIAction { [weak self] _ in
//            let image = self?.letterPhotoView.image
//            let content = self?.letterTextView.text
//            self?.delegate?.sendLetterToManittee(with: content, image)
//        }
//        self.sendButton.addAction(sendAction, for: .touchUpInside)
//    }

//    private func observeSendButtonEnabledState() {
//        self.letterTextView.sendHasTextValue = { [weak self] hasText in
//            self?.sendButtonObserver.hasText = hasText
//        }
//
//        self.letterPhotoView.sendHasImageValue = { [weak self] hasImage in
//            self?.sendButtonObserver.hasImage = hasImage
//        }
//    }
//
//    private func presentationControllerDidAttemptToDismiss() {
//        switch self.sendButtonObserver {
//        case let (hasText, hasImage) where hasText || hasImage:
//            self.delegate?.showActionSheet()
//        default:
//            self.delegate?.presentationControllerDidDismiss()
//        }
//    }


    
}

extension SendLetterView {
    
    // MARK: - base func

    func setupLayout() {
        self.addSubview(self.indicatorView)
        self.indicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(3)
            $0.width.equalTo(40)
        }

        self.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
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

    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }

    // MARK: - Private - func

    private func setupNavigationController(of viewController: UIViewController) {
        viewController.title = TextLiteral.createLetterViewControllerTitle
        viewController.navigationController?.presentationController?.delegate = self
        viewController.isModalInPresentation = true
    }

    private func setupNavigationItem(in navigationController: UINavigationController) {
        let navigationItem = navigationController.topViewController?.navigationItem
        let cancelButton = UIBarButtonItem(customView: self.cancelButton)
        let sendButton = UIBarButtonItem(customView: self.sendButton)

        sendButton.isEnabled = false

        navigationItem?.leftBarButtonItem = cancelButton
        navigationItem?.rightBarButtonItem = sendButton
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension SendLetterView: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.presentationControllerDidAttemptToDismiss()
    }
}
