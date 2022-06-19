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
        case openCapsule
        case openName
    }
    
    // MARK: - property
    
    @IBOutlet weak var joystickImageView: GIFImageView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var capsuleImageView: GIFImageView!
    @IBOutlet weak var openCapsuleImageView: GIFImageView!
    
    private var stageType: StageType = .joystick {
        didSet {
            hiddenImageView()
            setupGifImage()
        }
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenImageView()
        setupGifImage()
    }
    
    override func configUI() {
        super.configUI()
        informationLabel.font = .font(.regular, ofSize: 20)
    }
    
    // MARK: - func
    
    private func setupGifImage() {
        switch stageType {
        case .joystick:
            DispatchQueue.main.async {
                self.joystickImageView.animate(withGIFNamed: ImageLiterals.gifJoystick, animationBlock: nil)
            }
        case .capsule:
            self.joystickImageView.stopAnimatingGIF()
            DispatchQueue.main.async {
                self.capsuleImageView.animate(withGIFNamed: ImageLiterals.gifLogo, animationBlock: nil)
            }
        case .openCapsule:
            self.capsuleImageView.stopAnimatingGIF()
            DispatchQueue.main.async {
                self.openCapsuleImageView.animate(withGIFNamed: ImageLiterals.gifJoystick, animationBlock: nil)
            }
        case .openName:
            self.openCapsuleImageView.stopAnimatingGIF()
        }
    }
    
    private func hiddenImageView() {
        switch stageType {
        case .joystick:
            capsuleImageView.isHidden = true
        case .capsule:
            capsuleImageView.isHidden = false
            joystickImageView.isHidden = true
            informationLabel.isHidden = true
        case .openCapsule:
            openCapsuleImageView.isHidden = false
            capsuleImageView.isHidden = true
        case .openName:
            break
        }
    }
}
