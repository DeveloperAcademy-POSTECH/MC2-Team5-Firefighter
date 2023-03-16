//
//  LetterImageView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/02/20.
//

import UIKit

import SnapKit

protocol LetterImageViewDelegate: AnyObject {
    func downloadImageAsset(_ imageAsset: UIImage?)
    func closeButtonTapped()
}

final class LetterImageView: UIView {

    // MARK: - ui component

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        button.tintColor = .grey001
        return button
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.icSave, for: .normal)
        return button
    }()

    // MARK: - property

    private weak var delegate: LetterImageViewDelegate?

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAction()
        self.setupImagePinchGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func

    private func setupLayout() {
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)

        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(23)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(17)
            $0.width.height.equalTo(44)
        }

        self.addSubview(self.downloadButton)
        self.downloadButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(23)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(17)
        }
    }

    private func setupAction() {
        let downloadAction = UIAction { [weak self] _ in
            let downloadImage = self?.imageView.image
            self?.delegate?.downloadImageAsset(downloadImage)
        }
        self.downloadButton.addAction(downloadAction, for: .touchUpInside)

        let closeAction = UIAction { [weak self] _ in
            self?.delegate?.closeButtonTapped()
        }
        self.closeButton.addAction(closeAction, for: .touchUpInside)
    }

    private func setupImagePinchGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.didPinchImage(_:)))
        self.addGestureRecognizer(pinch)
    }

    func configureImageFrame() {
        self.scrollView.frame = self.bounds
        self.imageView.frame = self.scrollView.bounds
    }

    func configureImage(_ imageUrl: String) {
        self.imageView.loadImageUrl(imageUrl)
    }

    func configureDelegate(_ delegate: LetterImageViewDelegate) {
        self.delegate = delegate
    }

    // MARK: - selector

    @objc
    private func didPinchImage(_ pinch: UIPinchGestureRecognizer) {
        self.imageView.transform = self.imageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }
}


extension LetterImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
         return self.imageView
     }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let zoomScale = scrollView.zoomScale
        let contentInset = self.scrollViewDidChangeContentInsets(scrollView, with: zoomScale)
        scrollView.contentInset = contentInset
    }

    private func scrollViewDidChangeContentInsets(_ scrollView: UIScrollView, with zoomScale: CGFloat) -> UIEdgeInsets {
        guard zoomScale > 1 else { return .zero }
        guard let image = self.imageView.image else { return .zero }
        guard let zoomView = self.viewForZooming(in: scrollView) else { return .zero }

        let widthRatio = zoomView.frame.width / image.size.width
        let heightRatio = zoomView.frame.height / image.size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        let newWidth = image.size.width * ratio
        let newHeight = image.size.height * ratio

        let horizontalInset = 0.5 * (newWidth * scrollView.zoomScale > zoomView.frame.width ?
                          (newWidth - zoomView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
        let verticalInset = 0.5 * (newHeight * scrollView.zoomScale > zoomView.frame.height ? (newHeight - zoomView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))

        return UIEdgeInsets(top: verticalInset.rounded(),
                            left: horizontalInset.rounded(),
                            bottom: verticalInset.rounded(),
                            right: horizontalInset.rounded())
    }
}
