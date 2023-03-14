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

    private lazy var letterImageView: LetterImageView = LetterImageView()

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
        self.configureDelegation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureImageView()
    }

    // MARK: - func

    private func configureImageView() {
        self.letterImageView.configureImageFrame()
        self.letterImageView.configureImage(self.imageUrl)
    }

    private func configureDelegation() {
        self.letterImageView.configureDelegate(self)
    }
}

// MARK: - LetterImageViewDelegate
extension LetterImageViewController: LetterImageViewDelegate {
    func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func downloadImageAsset(_ imageAsset: UIImage?) {
        self.uploadImage(for: imageAsset) { [weak self] result in
            switch result {
            case .success(let description):
                self?.makeAlert(title: description.title,
                                message: description.message)
            case .failure(let error):
                self?.makeAlert(title: TextLiteral.letterImageViewControllerErrorTitle,
                                message: error.errorDescription)
            }
        }
    }

    private func uploadImage(for image: UIImage?, completionHandler: @escaping ((Result<(title: String, message: String), LetterImageError>) -> ())) {
        guard let image else { completionHandler(.failure(.invalidImage)); return }

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    completionHandler(.success((title: TextLiteral.letterImageViewControllerSuccessTitle,
                                                message: TextLiteral.letterImageViewControllerSuccessMessage)))
                } else {
                    completionHandler(.failure(.invalidPhotoLibrary))
                }
            }
        }
    }
}
