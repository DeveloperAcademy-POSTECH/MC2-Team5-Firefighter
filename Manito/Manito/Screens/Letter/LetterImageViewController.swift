//
//  LetterImageViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/18.
//

import Photos
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

extension LetterImageViewController: LetterImageViewDelegate {
    func downloadImageAsset(_ imageAsset: UIImage?) {
        // MARK: - Error에 대한 처리 필요..
        guard let imageAsset = imageAsset else {
            self.makeAlert(title: TextLiteral.letterImageViewControllerErrorTitle,
                           message: TextLiteral.letterImageViewControllerErrorMessage)
            return
        }

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: imageAsset)
        }) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.makeAlert(title: TextLiteral.letterImageViewControllerSuccessTitle,
                                   message: TextLiteral.letterImageViewControllerSuccessMessage)
                } else if let error = error {
                    Logger.debugDescription(error)
                    self.makeAlert(title: TextLiteral.letterImageViewControllerErrorTitle,
                                   message: TextLiteral.letterImageViewControllerErrorMessage)
                }
            }
        }
    }

    func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}
