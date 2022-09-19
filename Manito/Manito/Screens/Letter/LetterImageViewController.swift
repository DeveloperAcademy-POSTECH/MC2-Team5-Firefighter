//
//  LetterImageViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/18.
//

import UIKit

import SnapKit

final class LetterImageViewController: BaseViewController {
    
    // MARK: - property
    
    private let scrollView = UIScrollView()
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        button.tintColor = .grey001
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: - life cycle
    
    override func render() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(23)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(17)
            $0.width.height.equalTo(44)
        }
    }
    
    override func configUI() {
        setupScrollView()
        setupImageView()
        setImagePinchGesture()
    }
    
    private func setupScrollView() {
        scrollView.frame = view.bounds
        scrollView.delegate = self
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupImageView() {
        imageView.frame = scrollView.bounds
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setImagePinchGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didPinchImage(_:)))
        view.addGestureRecognizer(pinch)
    }
    
    // MARK: - selector
    
    @objc private func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func didPinchImage(_ pinch: UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }
}

extension LetterImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
         return self.imageView
     }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            guard let image = imageView.image else { return }
            guard let zoomView = viewForZooming(in: scrollView) else { return }
            
            let widthRatio = zoomView.frame.width / image.size.width
            let heightRatio = zoomView.frame.height / image.size.height
            let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
            
            let newWidth = image.size.width * ratio
            let newHeight = image.size.height * ratio
            
            let left = 0.5 * (newWidth * scrollView.zoomScale > zoomView.frame.width ?
                              (newWidth - zoomView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
            let top = 0.5 * (newHeight * scrollView.zoomScale > zoomView.frame.height ? (newHeight - zoomView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))
            
            scrollView.contentInset = UIEdgeInsets(top: top.rounded(), left: left.rounded(), bottom: top.rounded(), right: left.rounded())
        } else {
            scrollView.contentInset = .zero
        }
    }
}
