//
//  SendLetterView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/24.
//

import Combine
import UIKit

import SnapKit

final class SendLetterView: UIView, BaseViewType {

    typealias Message = (content: String?, image: UIImage?)
    typealias ActionDetail = (message: String,
                              titles: [String],
                              styles: [UIAlertAction.Style],
                              actions: [((UIAlertAction) -> Void)?])

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
    private let letterTextView: SendLetterTextView = SendLetterTextView()
    private let letterPhotoView: SendLetterPhotoView = SendLetterPhotoView()

    // MARK: - property

    var textViewChangedPublisher: AnyPublisher<String, Never> {
        return self.letterTextView.textSubject.eraseToAnyPublisher()
    }

    var photoButtonTapPublisher: AnyPublisher<ActionDetail, Never> {
        return self.letterPhotoView.photoButtonPublisher
    }

    var cancelButtonTapPublisher: AnyPublisher<Bool, Never> {
        return self.cancelButton.tapPublisher
            .map { [weak self] in
                guard let self else { return false }
                return self.letterTextView.hasTextSubject.value || self.letterPhotoView.hasImageSubject.value
            }
            .eraseToAnyPublisher()
    }

    var sendButtonTapPublisher: AnyPublisher<Message, Never> {
        return self.sendButton.tapPublisher
            .map { [weak self] in
                guard let self else { return (nil, nil) }
                return (self.letterTextView.textSubject.value, self.letterPhotoView.imageSubject.value)
            }
            .eraseToAnyPublisher()
    }

    private var cancelBag: Set<AnyCancellable> = Set()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.bindUI()
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

    func updateSendButtonIsEnabled(to isEnabled: Bool) {
        self.sendButton.isEnabled = isEnabled
    }

    func updateTextView(count: Int, maxCount: Int) {
        self.letterTextView.updateCounter(count, maxCount: maxCount)
    }

    func updateTextView(content: String) {
        self.letterTextView.updateTextViewContent(to: content)
    }
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

    private func bindUI() {
        Publishers.CombineLatest(self.letterTextView.hasTextSubject, self.letterPhotoView.hasImageSubject)
            .map { $0 || $1 }
            .assign(to: \.isEnabled, on: self.sendButton)
            .store(in: &self.cancelBag)
    }
}
