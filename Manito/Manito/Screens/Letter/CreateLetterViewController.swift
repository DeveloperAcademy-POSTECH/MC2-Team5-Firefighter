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
    
    private func setupNavigationItem() {
        let cancelButton = makeBarButtonItem(with: cancelButton)
        let sendButton = makeBarButtonItem(with: sendButton)
        
        sendButton.isEnabled = false
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = sendButton
    }
    
    private func setupButtonAction() {
        let photoAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            let alertController = self.applyActionSheet()
            self.present(alertController, animated: true)
        }
        let sendAction = UIAction { _ in
            Logger.debugDescription("눌렸습니다.")
        }
        
        letterPhotoView.importPhotosButton.addAction(photoAction, for: .touchUpInside)
        sendButton.addAction(sendAction, for: .touchUpInside)
    }
    
    private func applyActionSheet() -> UIAlertController {
        let alertController = UIAlertController(title: "", message: "마니또에게 보낼 사진을 선택해봐요.", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "사진 촬영", style: .default) { _ in
            Logger.debugDescription("사진 촬영 시작")
        })
        alertController.addAction(UIAlertAction(title: "사진 보관함에서 선택", style: .default) { _ in
            Logger.debugDescription("사진 보관함에서 선택합니다.")
        })
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        return alertController
    }
}
