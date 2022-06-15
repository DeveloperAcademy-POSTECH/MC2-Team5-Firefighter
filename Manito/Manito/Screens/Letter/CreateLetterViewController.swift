//
//  CreateLetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import UIKit

import SnapKit

final class CreateLetterViewController: BaseViewController {
    
    // MARK: - property
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.layer.cornerRadius = 2
        return view
    }()
    private let cancelButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        button.setTitle("취소", for: .normal)
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
    private let missionView = IndividualMissionView(mission: "1000원 이하의 선물 주고 인증샷 받기")
    private let letterTextView = LetterTextView()
    private let letterPhotoView = LetterPhotoView()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSendButtonEnabled()
        setupNavigationItem()
        setupButtonAction()
    }
    
    override func render() {
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(3)
            $0.width.equalTo(40)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        scrollContentView.addSubview(missionView)
        missionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        scrollContentView.addSubview(letterTextView)
        letterTextView.snp.makeConstraints {
            $0.top.equalTo(missionView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        scrollContentView.addSubview(letterPhotoView)
        letterPhotoView.snp.makeConstraints {
            $0.top.equalTo(letterTextView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(105)
        }
    }
    
    override func configUI() {
        super.configUI()
        
        navigationController?.presentationController?.delegate = self
        isModalInPresentation = true
    }
    
    override func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
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
        
        title = "쪽지 작성하기"
    }
    
    // MARK: - func
    
    private func checkSendButtonEnabled() {
        letterTextView.applySendButtonEnabled = { [weak self] in
            self?.changeButtonEnabledState()
        }
        letterPhotoView.applySendButtonEnabled = { [weak self] in
            self?.changeButtonEnabledState()
        }
    }
    
    private func changeButtonEnabledState() {
        let hasText = letterTextView.letterTextView.hasText
        let hasImage = letterPhotoView.importPhotosButton.imageView?.image != ImageLiterals.icCamera
        let canEnabled = hasText || hasImage
        
        sendButton.isEnabled = canEnabled
    }
    
    private func setupNavigationItem() {
        let cancelButton = makeBarButtonItem(with: cancelButton)
        let sendButton = makeBarButtonItem(with: sendButton)
        
        sendButton.isEnabled = false
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = sendButton
    }
    
    private func setupButtonAction() {
        let cancelAction = UIAction { [weak self] _ in
            self?.presentationControllerDidAttemptToDismissAction()
        }
        let sendAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        
        cancelButton.addAction(cancelAction, for: .touchUpInside)
        sendButton.addAction(sendAction, for: .touchUpInside)
    }
    
    private func presentationControllerDidAttemptToDismissAction() {
        let hasText = letterTextView.letterTextView.hasText
        let hasImage = letterPhotoView.importPhotosButton.imageView?.image != ImageLiterals.icCamera
        guard hasText || hasImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        presentActionSheet()
    }
    
    private func presentActionSheet() {
        let dismissAction: ((UIAlertAction) -> ()) = { [weak self] _ in
            self?.resignFirstResponder()
            self?.dismiss(animated: true, completion: nil)
        }
        makeActionSheet(actionTitles: ["변경 사항 폐기", "취소"],
                        actionStyle: [.destructive, .cancel],
                        actions: [dismissAction, nil])
    }
}

extension CreateLetterViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        presentationControllerDidAttemptToDismissAction()
    }
}
