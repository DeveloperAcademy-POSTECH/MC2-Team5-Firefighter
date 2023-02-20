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

    private let letterImageView: LetterImageView = LetterImageView()

    // MARK: - property

    private let imageUrl: String

    // MARK: - init

    init(imageUrl: String) {
        self.imageUrl = imageUrl
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    override func loadView() {
        self.view = self.letterImageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureImage()
        self.configureDelegation()
    }

    // MARK: - func

    private func configureImage() {
        self.letterImageView.configureImage(self.imageUrl)
    }

    private func configureDelegation() {
        self.letterImageView.configureDelegate(self)
    }
}

// MARK: - LetterImageViewDelegate
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
