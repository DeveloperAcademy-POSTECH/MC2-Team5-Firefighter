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
    
    // MARK: - property
    
    private var messages: [MessageListItem] = []
    
    private var cancelBag: Set<AnyCancellable> = Set()
    
    private var viewModel: any BaseViewModelType
    
    // MARK: - init
    
    init(viewModel: any BaseViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        self.bindViewModel()
        self.bindUI()
        self.setupNavigation()
    }

    // MARK: - func
    
    private func configureUI() {
        self.memoryView.configureNavigationBar(of: self)
        self.memoryView.configureDelegation(self)
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }

    private func transformedOutput() -> MemoryViewModel.Output? {
        guard let viewModel = self.viewModel as? MemoryViewModel else { return nil }
        let input = MemoryViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            segmentControlValueChanged: self.memoryView.segmentControlPublisher
        )
        return viewModel.transform(from: input)
    }

    private func bindOutputToViewModel(_ output: MemoryViewModel.Output?) {
        guard let output = output else { return }

        output.member
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.updateMemoryView(announcingText: data.announcingText,
                                           nickname: data.memberInfo.nickname,
                                           colorIndex: data.memberInfo.colorIndex)
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            })
            .store(in: &self.cancelBag)
        
        output.messages
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.updateMessages(data)
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            })
            .store(in: &self.cancelBag)
    }
    
    private func bindUI() {
        self.memoryView.shareButtonPublisher
            .map { [URLLiteral.Memory.instagramBundle: $0] }
            .sink(receiveValue: { [weak self] in
                self?.handleInstagramShare($0)
            })
            .store(in: &self.cancelBag)
    }
}

// MARK: - Helper
extension MemoryViewController {
    private func updateMemoryView(announcingText: String, nickname: String, colorIndex: Int) {
        let backgroundColor = DefaultCharacterType.allCases[colorIndex].backgroundColor
        let image = DefaultCharacterType.allCases[colorIndex].image
        let detail = (announcingText: announcingText, nickname: nickname, backgroundColor: backgroundColor, image: image)
        self.memoryView.updateMemoryView(detail)
    }
    
    private func updateMessages(_ messages: [MessageListItem]) {
        self.messages = messages
        self.memoryView.updateCollectionView()
    }
    
    private func handleInstagramShare(_ items: [String: Any]) {
        if let shareURL = URL(string: URLLiteral.Memory.instagram) {
            if UIApplication.shared.canOpenURL(shareURL) {
                let options = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)]
                UIPasteboard.general.setItems([items], options: options)
                UIApplication.shared.open(shareURL)
            } else {
                self.showErrorAlert(title: TextLiteral.Memory.Error.instaTitle.localized(),
                                    message: TextLiteral.Memory.Error.instaMessage.localized())
            }
        }
    }
    
    private func showErrorAlert(title: String = TextLiteral.Common.Error.title.localized(),
                                message: String) {
        self.makeAlert(title: title, message: message)
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
        cell.delegate = self
        return cell
    }
}

// MARK: - MemoryCollectionViewCellDelegate
extension MemoryViewController: MemoryCollectionViewCellDelegate {
    func didTapPhotoImage(_ imageURL: String) {
        let viewController = LetterImageViewController(imageUrl: imageURL)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
}
