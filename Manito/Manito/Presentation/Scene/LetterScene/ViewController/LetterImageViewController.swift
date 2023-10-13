//
//  LetterImageViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/18.
//

import Combine
import Photos
import UIKit

final class LetterImageViewController: UIViewController, Navigationable {

    // MARK: - ui component

    private lazy var letterImageView: LetterImageView = LetterImageView()

    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()

    private let imageUrl: String

    // MARK: - init

    init(imageUrl: String) {
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    override func loadView() {
        self.view = self.letterImageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.bindUI()
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
    
    private func bindUI() {
        self.letterImageView.closeButtonPublisher
            .sink(receiveValue: { [weak self] in
                self?.dismiss(animated: true)
            })
            .store(in: &self.cancelBag)
        
        self.letterImageView.downloadButtonPublisher
            .sink(receiveValue: { image in
                self.uploadImage(for: image) { [weak self] result in
                    switch result {
                    case .success(let description):
                        self?.makeAlert(title: description.title,
                                        message: description.message)
                    case .failure(let error):
                        self?.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                                        message: error.errorDescription)
                    }
                }
            })
            .store(in: &self.cancelBag)
    }
    
    private func uploadImage(for image: UIImage?, completionHandler: @escaping ((Result<(title: String, message: String), LetterImageError>) -> ())) {
        guard let image else { completionHandler(.failure(.invalidImage)); return }

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    completionHandler(.success((title: TextLiteral.Letter.saveAlertTitle.localized(),
                                                message: TextLiteral.Letter.saveAlertMessage.localized())))
                } else {
                    completionHandler(.failure(.invalidPhotoLibrary))
                }
            }
        }
    }
}
