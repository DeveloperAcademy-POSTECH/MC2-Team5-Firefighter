//
//  LetterImageViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/18.
//

import UIKit

final class LetterImageViewController: BaseViewController {

    // MARK: - ui component


    // MARK: - init

    init(image: UIImage) {
        self.imageView.image = image
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("\(#file) is dead")
    }
}
