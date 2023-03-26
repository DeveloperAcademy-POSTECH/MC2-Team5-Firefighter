//
//  SelectManittoViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/19.
//

import UIKit

import Gifu

final class SelectManittoViewController: BaseViewController {

    private enum SelectionStage {
        case showJoystick, showCapsule, openName, openButton
    }

    // MARK: - ui component

    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 20)
        label.text = TextLiteral.selectManittoViewControllerInformationText
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 30)
        return label
    }()
    private let confirmButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.confirm
        return button
    }()
    private let joystickBackgroundView: UIView = UIView()
    private let joystickImageView: GIFImageView = GIFImageView(image: UIImage(named: ImageLiterals.gifJoystick))
    private let openCapsuleImageView: GIFImageView = GIFImageView(image: UIImage(named: ImageLiterals.gifCapsule))

    // MARK: - property

    var roomId: String?
    var manitteeName: String?
    private var stageType: SelectionStage = .showJoystick {
        didSet {
            self.hiddenImageView()
            self.setupGifImage()
        }
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButtonAction()
        self.setupSwipeGesture()
        self.setupGifImage()
        self.hiddenImageView()
    }

    // MARK: - override

    override func setupLayout() {
        self.view.addSubview(self.joystickBackgroundView)
        self.joystickBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
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

        self.view.addSubview(self.openCapsuleImageView)
        self.openCapsuleImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.equalTo(199)
            $0.height.equalTo(285)
        }

        self.view.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.openCapsuleImageView.snp.centerY)
        }

        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(31)
        }
    }

    override func configureUI() {
        super.configureUI()

        if let manittee = self.manitteeName {
            self.nameLabel.text = manittee
        }
    }

    // MARK: - func

    private func setupButtonAction() {
        let okAction = UIAction { [weak self] _ in
            guard let presentingViewController = self?.presentingViewController as? UINavigationController,
                  let roomId = self?.roomId
            else { return }
            let viewController = DetailingViewController(roomId: roomId)
            presentingViewController.popViewController(animated: true)
            presentingViewController.pushViewController(viewController, animated: false)
            self?.dismiss(animated: true)
        }
        self.confirmButton.addAction(okAction, for: .touchUpInside)
    }

    private func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.joystickBackgroundView.addGestureRecognizer(swipeLeft)
        self.joystickBackgroundView.addGestureRecognizer(swipeRight)
    }

    private func setupGifImage() {
        switch stageType {
        case .showJoystick:
            DispatchQueue.main.async {
                self.joystickImageView.animate(withGIFNamed: ImageLiterals.gifJoystick)
            }
        case .showCapsule:
            self.joystickImageView.stopAnimatingGIF()
            DispatchQueue.main.async {
                self.openCapsuleImageView.animate(withGIFNamed: ImageLiterals.gifCapsule, loopCount: 1, animationBlock: { [weak self] in
                    self?.stageType = .openName
                })
            }
        case .openName:
            self.openCapsuleImageView.stopAnimatingGIF()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.stageType = .openButton
            })
        case .openButton:
            break
        }
    }

    private func hiddenImageView() {
        switch stageType {
        case .showJoystick:
            self.nameLabel.alpha = 0.0
            self.openCapsuleImageView.isHidden = true
            self.confirmButton.isHidden = true
        case .showCapsule:
            self.openCapsuleImageView.isHidden = false
            self.joystickBackgroundView.isHidden = true
        case .openName:
            self.nameLabel.fadeIn()
        case .openButton:
            self.confirmButton.isHidden = false
        }
    }

    // MARK: - selector

    @objc
    private func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .left, .right:
                self.stageType = .showCapsule
            default:
                break
            }
        }
    }
}
