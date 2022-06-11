//
//  LetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

final class LetterViewController: BaseViewController {
    
    // MARK: - property
    
    private let backButton: UIButton = {
        let button = UIButton(frame: .init(origin: .zero, size: .init(width: 44, height: 44)))
        button.setImage(ImageLiterals.icBack, for: .normal)
        button.tintColor = .white
        return button
    }()

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    // MARK: - func
    
    private func setupNavigationBar() {
        let leftOffsetBackButton = removeBarButtonItemOffset(with: backButton, offsetX: 10)
        let backButton = makeBarButtonItem(with: leftOffsetBackButton)
        
        navigationItem.leftBarButtonItem = backButton
    }
}
