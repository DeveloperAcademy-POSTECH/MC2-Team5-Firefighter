//
//  MemoryViewController.swift
//  Manito
//
//  Created by 최성희 on 2022/06/14.
//

import UIKit

import SnapKit

final class MemoryViewController: UIViewController, Navigationable {
    
    private enum MemoryType: Int {
        case manittee = 0
        case manitto = 1
        
        var announcingText: String {
            switch self {
            case .manittee:
                return TextLiteral.Memory.manitteContent.localized()
            case .manitto:
                return TextLiteral.Memory.manittoContent.localized()
            }
        }
    }
    
    // MARK: - properties
    
    private var memoryType: MemoryType = .manittee {
        willSet {
            setupData(with: newValue)
            self.memoryCollectionView.reloadData()
        }
    }
    private var memory: MemoryDTO?
    private var roomId: String
    
    // MARK: - init
    
    init(roomId: String) {
        self.roomId = roomId
        super.init(nibName: nil, bundle: nil)
        requestMemory(roomId: roomId)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle

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
    
    // MARK: - network
    
    private func setupData(with state: MemoryType) {
        announcementLabel.text = state.announcingText
        switch state {
        case .manittee:
            guard let manitteeColorIndex = memory?.memoriesWithManittee?.member?.colorIndex else { return }
            nicknameLabel.text = memory?.memoriesWithManittee?.member?.nickname
            characterBackView.backgroundColor = DefaultCharacterType.allCases[manitteeColorIndex].backgroundColor
            characterImageView.image = DefaultCharacterType.allCases[manitteeColorIndex].image
        case .manitto:
            guard let manittoColorIndex = memory?.memoriesWithManitto?.member?.colorIndex else { return }
            nicknameLabel.text = memory?.memoriesWithManitto?.member?.nickname
            characterBackView.backgroundColor = DefaultCharacterType.allCases[manittoColorIndex].backgroundColor
            characterImageView.image = DefaultCharacterType.allCases[manittoColorIndex].image
        }
    }
    
}

extension MemoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch memoryType {
        case .manittee:
            guard let count = memory?.memoriesWithManittee?.messages?.count else { return 0 }
            return count
        case .manitto:
            guard let count = memory?.memoriesWithManitto?.messages?.count else { return 0 }
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MemoryCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        var imageUrl: String

        switch memoryType {
        case .manittee:
            imageUrl = memory?.memoriesWithManittee?.messages?[indexPath.item].imageUrl ?? ""
            cell.setData(imageUrl: memory?.memoriesWithManittee?.messages?[indexPath.item].imageUrl,
                         content: memory?.memoriesWithManittee?.messages?[indexPath.item].content)
        case .manitto:
            imageUrl = memory?.memoriesWithManitto?.messages?[indexPath.item].imageUrl ?? ""
            cell.setData(imageUrl: memory?.memoriesWithManitto?.messages?[indexPath.item].imageUrl,
                         content: memory?.memoriesWithManitto?.messages?[indexPath.item].content)
        }

        cell.didTappedImage = { [weak self] image in
            let viewController = LetterImageViewController(imageUrl: imageUrl)
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .crossDissolve
            self?.present(viewController, animated: true)
        }

        return cell
    }
}
