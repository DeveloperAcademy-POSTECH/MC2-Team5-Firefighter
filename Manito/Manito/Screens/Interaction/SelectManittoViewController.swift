//
//  SelectManittoViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/19.
//

import UIKit

final class SelectManittoViewController: BaseViewController {

    private enum SelectionStage {
        case showJoystick, showCapsule, openName, openButton
    }

    // MARK: - property

    private let roomId: String
    var manitteeNickname: String?
    private var stageType: SelectionStage = .showJoystick {
        didSet {
            self.hiddenImageView()
            self.setupGifImage()
        }
    }

    // MARK: - init

    init(roomId: String, manitteeNickname: String) {
        self.roomId = roomId
        self.manitteeNickname = manitteeNickname
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGifImage()
        self.hiddenImageView()
    }
    

    // MARK: - func


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

}
