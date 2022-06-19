//
//  SplashViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import UIKit

import Gifu

final class SplashViewController: BaseViewController {

    // MARK: - property
    
    @IBOutlet weak var gifImageView: GIFImageView!
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGifImage()
    }
    
    // MARK: - func
    
    private func setupGifImage() {
        DispatchQueue.main.async {
            self.gifImageView.animate(withGIFNamed: ImageLiterals.gifLogo, animationBlock: nil)
        }
    }
}
