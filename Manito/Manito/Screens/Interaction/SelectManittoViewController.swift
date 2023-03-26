//
//  SelectManittoViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/19.
//

import UIKit

import Gifu

final class SelectManittoViewController: BaseViewController {
    var roomId: String?

    private enum StageType {
        case joystick
        case capsule
        case openName
        case openButton
    }

    // MARK: - property

    @IBOutlet weak var joystickBackgroundView: UIView!
    @IBOutlet weak var joystickImageView: GIFImageView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var openCapsuleImageView: GIFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var confirmButton: MainButton!

    private lazy var okAction: UIAction = {
        let action = UIAction { [weak self] _ in
            guard let navigationController = self?.presentingViewController as? UINavigationController,
                  let roomId = self?.roomId
            else { return }
            let viewController = DetailingViewController(roomId: roomId)
            navigationController.popViewController(animated: true)
            navigationController.pushViewController(viewController, animated: false)
            self?.dismiss(animated: true)
        }
        return action
    }()

    var manitteeName: String?
    private var stageType: StageType = .joystick {
        didSet {
            hiddenImageView()
            setupGifImage()
        }
    }
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeGesture()
        hiddenImageView()
        setupGifImage()
    }

    override func configureUI() {
        super.configureUI()

        informationLabel.font = .font(.regular, ofSize: 20)
        nameLabel.font = .font(.regular, ofSize: 30)
        if let manittee = manitteeName {
            nameLabel.text = manittee
        }
        confirmButton.title = TextLiteral.confirm
        confirmButton.addAction(okAction, for: .touchUpInside)

    }

    // MARK: - func

    private func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right

        joystickBackgroundView.addGestureRecognizer(swipeLeft)
        joystickBackgroundView.addGestureRecognizer(swipeRight)
    }

    private func setupGifImage() {
        switch stageType {
        case .joystick:
            DispatchQueue.main.async {
                self.joystickImageView.animate(withGIFNamed: ImageLiterals.gifJoystick, animationBlock: nil)
            }
        case .capsule:
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
        case .joystick:
            nameLabel.alpha = 0.0
            openCapsuleImageView.isHidden = true
            confirmButton.isHidden = true
        case .capsule:
            openCapsuleImageView.isHidden = false
            joystickBackgroundView.isHidden = true
        case .openName:
            nameLabel.fadeIn()
        case .openButton:
            confirmButton.isHidden = false
        }
    }

    // MARK: - selector

    @objc
    private func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .left:
                stageType = .capsule
            case .right:
                stageType = .capsule
            default:
                break
            }
        }
    }
}
