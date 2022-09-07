//
//  InvitedCodeViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class InvitedCodeViewController: BaseViewController {

    // MARK: - property
    private let invitedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.imgCodeBackground
        return imageView
    }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - configure
    override func render() {
        view.addSubview(invitedImageView)
        invitedImageView
    }
    
    // MARK: - selectors
    // MARK: - functions
}
