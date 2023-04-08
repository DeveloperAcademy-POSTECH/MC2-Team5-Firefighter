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

    @IBOutlet weak var joystickBackgroundView: UIView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var joystickImageView: GIFImageView!
    @IBOutlet weak var openCapsuleImageView: GIFImageView!
    @IBOutlet weak var confirmButton: MainButton!

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

    override func configureUI() {
        super.configureUI()

        self.informationLabel.font = .font(.regular, ofSize: 20)
        self.nameLabel.font = .font(.regular, ofSize: 30)

        self.confirmButton.title = TextLiteral.confirm
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
