//
//  SelectManittoViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/19.
//

import UIKit

import Gifu

final class SelectManittoViewController: BaseViewController {

    private enum StageType {
        case joystick
        case capsule
        case openName
        case openButton
    }

    // MARK: - property

    @IBOutlet weak var joystickImageView: GIFImageView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var openCapsuleImageView: GIFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var confirmButton: MainButton!

    private lazy var okAction: UIAction = {
        let action = UIAction { _ in
            guard let parentViewController = self.presentingViewController as? UINavigationController else { return }
            self.dismiss(animated: true)
            let storyboard = UIStoryboard(name: "DetailIng", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: DetailIngViewController.className) as? DetailIngViewController else { return }
            parentViewController.popViewController(animated: false)
            parentViewController.pushViewController(viewController, animated: true)
        }
        return action
    }()

    private var manittiName: String = "리비"
    private var stageType: StageType = .joystick {
        didSet {
            hiddenImageView()
            setupGifImage()
        }
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeGesture()
        hiddenImageView()
        setupGifImage()
    }

    override func configUI() {
        super.configUI()

        joystickImageView.isUserInteractionEnabled = true

        informationLabel.font = .font(.regular, ofSize: 20)
        nameLabel.font = .font(.regular, ofSize: 30)
        nameLabel.text = manittiName
        confirmButton.title = "확인"
        confirmButton.addAction(okAction, for: .touchUpInside)

    }

    // MARK: - func

    private func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right

        joystickImageView.addGestureRecognizer(swipeLeft)
        joystickImageView.addGestureRecognizer(swipeRight)
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
            joystickImageView.isHidden = true
            informationLabel.isHidden = true
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
