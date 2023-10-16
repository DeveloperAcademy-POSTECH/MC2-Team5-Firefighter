//
//  MemoryViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/16/23.
//

import Combine
import UIKit

import SnapKit

final class MemoryViewController: UIViewController, Navigationable {
    
    // MARK: - ui component
    
    private let memoryView = MemoryView()
    
    // MARK: - properties
    
    private var messages: [MessageListItem] = []
    
    private let viewModel: any BaseViewModelType
    
    // MARK: - init
    
    init(viewModel: any BaseViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.memoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }

    // MARK: - func
    
    private func configureUI() {
        self.memoryView.configureNavigationBar(of: self)
        self.memoryView.configureDelegation(self)
    }
    
    private func setupAction() {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }

            // FIXME: - URLLiteral로 이동 시키기
            if let storyShareURL = URL(string: "instagram-stories://share") {
                if UIApplication.shared.canOpenURL(storyShareURL) {
                    let renderer = UIGraphicsImageRenderer(size: self.shareBoundView.bounds.size)
                    let renderImage = renderer.image { _ in
                        self.shareBoundView.drawHierarchy(in: self.shareBoundView.bounds, afterScreenUpdates: true)
                    }
                    guard let imageData = renderImage.pngData() else {return}
                    let pasteboardItems: [String: Any] = [
                        "com.instagram.sharedSticker.stickerImage": imageData
                    ]
                    let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)]
                    
                    UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                    UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)
                } else {
                    self.makeAlert(title: TextLiteral.Memory.Error.instaTitle.localized(),
                                   message: TextLiteral.Memory.Error.instaMessage.localized())
                }
            }
        }
        shareButton.addAction(action, for: .touchUpInside)
    }
    
    private func updateMemoryView(announcingText: String, nickname: String, colorIndex: Int) {
        let backgroundColor = DefaultCharacterType.allCases[colorIndex].backgroundColor
        let image = DefaultCharacterType.allCases[colorIndex].image
        let detail = (announcingText: announcingText, nickname: nickname, backgroundColor: backgroundColor, image: image)
        self.memoryView.updateMemoryView(detail)
    }
}

// MARK: - UICollectionViewDataSource
extension MemoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MemoryCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let message = self.messages[indexPath.item]
        
        cell.setData(imageUrl: message.imageUrl, content: message.content)
        cell.didTappedImage = { [weak self] image in
            let viewController = LetterImageViewController(imageUrl: image)
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .crossDissolve
            self?.present(viewController, animated: true)
        }

        return cell
    }
}
