//
//  CreateLetterView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/02/28.
//

import UIKit

import SnapKit

final class CreateLetterView: UIView {

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
    private let scrollContentView: UIView = UIView()
    private let letterTextView: CreateLetterTextView = CreateLetterTextView()
    private let letterPhotoView: CreateLetterPhotoView = CreateLetterPhotoView()
    private lazy var missionView: IndividualMissionView = IndividualMissionView(mission: self.mission)

    // MARK: - property

    private var isSendEnabled: (hasText: Bool, hasImage: Bool) = (false, false) {
        willSet {
            self.sendButton.isEnabled = newValue.hasText || newValue.hasImage
        }
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAction()
        self.setupImagePinchGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func

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

    private func setupLayout() {
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

    private func checkSendButtonEnabled() {
        self.letterTextView.setSendButtonEnabled = { [weak self] hasText in
            self?.isSendEnabled.hasText = hasText
        }

        self.letterPhotoView.setSendButtonEnabled = { [weak self] hasImage in
            self?.isSendEnabled.hasImage = hasImage
        }
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
        let hasText = self.isSendEnabled.hasText
        let hasImage = self.isSendEnabled.hasImage
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
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension CreateLetterView: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.presentationControllerDidAttemptToDismissAction()
    }
}
