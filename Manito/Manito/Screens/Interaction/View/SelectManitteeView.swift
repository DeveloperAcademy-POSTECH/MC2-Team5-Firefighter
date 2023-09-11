//
//  SelectManitteeView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/28.
//

import UIKit

import Gifu
import SnapKit

protocol SelectManitteeViewDelegate: AnyObject {
    func confirmButtonDidTap()
    func moveToNextStep()
}

final class SelectManitteeView: UIView, BaseViewType {

    // MARK: - ui component

    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 20)
        label.text = TextLiteral.selectManitteeViewControllerInformationText
        label.numberOfLines = 2
        label.addLabelSpacing()
        label.textAlignment = .center
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 30)
        label.alpha = 0.0
        return label
    }()
    private let confirmButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.confirm
        return button
    }()
    private let joystickBackgroundView: UIView = UIView()
    private let joystickImageView: GIFImageView = GIFImageView()
    private let openCapsuleImageView: GIFImageView = GIFImageView()

    // MARK: - property

    private weak var delegate: SelectManitteeViewDelegate?

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupButtonAction()
        self.setupSwipeGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func

    func setupLayout() {
        self.addSubview(self.joystickBackgroundView)
        self.joystickBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }

        self.joystickBackgroundView.addSubview(self.joystickImageView)
        self.joystickImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.height.equalTo(140)
        }

        self.joystickBackgroundView.addSubview(self.informationLabel)
        self.informationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.joystickImageView.snp.bottom).offset(63)
        }

        self.addSubview(self.openCapsuleImageView)
        self.openCapsuleImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.equalTo(199)
            $0.height.equalTo(285)
        }

        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.openCapsuleImageView.snp.centerY)
        }

        self.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(31)
        }
    }

    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }

    // MARK: - func

    private func setupButtonAction() {
        let confirmAction = UIAction { [weak self] _ in
            self?.delegate?.confirmButtonDidTap()
        }
        self.confirmButton.addAction(confirmAction, for: .touchUpInside)
    }

    private func setupSwipeGesture() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left
        swipeRightGesture.direction = UISwipeGestureRecognizer.Direction.right
        self.joystickBackgroundView.addGestureRecognizer(swipeLeftGesture)
        self.joystickBackgroundView.addGestureRecognizer(swipeRightGesture)
    }

    private func setupShowJoystickConfiguration() {
        self.joystickImageView.animate(withGIFNamed: GIFSet.joystick)
    }

    private func setupShowCapsuleConfiguration() {
        self.joystickImageView.stopAnimatingGIF()
        self.openCapsuleImageView.animate(withGIFNamed: GIFSet.capsule, loopCount: 1, animationBlock: { [weak self] in
            self?.delegate?.moveToNextStep()
        })
    }

    private func setupOpenNameConfiguration() {
        self.nameLabel.fadeIn()
        self.openCapsuleImageView.stopAnimatingGIF()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.delegate?.moveToNextStep()
        })
    }

    private func setupHiddenStepView(at step: Int) {
        self.joystickBackgroundView.isHidden = !(step == 0)
        self.openCapsuleImageView.isHidden = !(step == 1 || step == 2 || step == 3)
        self.nameLabel.isHidden = !(step == 2 || step == 3)
        self.confirmButton.isHidden = !(step == 3)
    }

    func configureDelegation(_ delegate: SelectManitteeViewDelegate) {
        self.delegate = delegate
    }

    func configureUI(manitteeNickname: String) {
        self.nameLabel.text = manitteeNickname
    }

    func manageStepView(step: Int) {
        self.setupHiddenStepView(at: step)
        switch step {
        case 0: self.setupShowJoystickConfiguration()
        case 1: self.setupShowCapsuleConfiguration()
        case 2: self.setupOpenNameConfiguration()
        default: break
        }
    }

    // MARK: - selector

    @objc
    private func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .left, .right: self.delegate?.moveToNextStep()
            default: break
            }
        }
    }
}
