//
//  LetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import Combine
import UIKit

final class LetterViewController: UIViewController, Navigationable {
    
    typealias MessageDetail = (roomId: String, mission: String, missionId: String, manitteeId: String)

    enum Section: CaseIterable {
        case main
    }

    // MARK: - ui component

    private let letterView: LetterView = LetterView()

    private var dataSource: UICollectionViewDiffableDataSource<Section, MessageListItem>!
    private var snapShot: NSDiffableDataSourceSnapshot<Section, MessageListItem>!

    // MARK: - property
    
    private let mailManager: MailComposeManager = MailComposeManager()

    private let segmentValueSubject: PassthroughSubject<Int, Never> = PassthroughSubject()
    private let reportSubject: PassthroughSubject<String, Never> = PassthroughSubject()
    private let refreshSubject: PassthroughSubject<Void, Never> = PassthroughSubject()

    private var cancelBag: Set<AnyCancellable> = Set()

    private var viewModelOutput: LetterViewModel.Output?

    private let viewModel: any BaseViewModelType

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
        self.view = self.letterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDataSource()
        self.bindViewModel()
        self.setupMailManager()
        self.setupNavigation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.letterView.configureNavigationBar(of: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.letterView.removeGuideView()
    }
    
    // MARK: - func
    
    private func setupMailManager() {
        self.mailManager.viewController = self
    }

    // MARK: - func - bind

    private func bindViewModel() {
        let output = self.transformedOutput()
        self.viewModelOutput = output
        self.bindOutputToViewModel(output)
    }

    private func transformedOutput() -> LetterViewModel.Output? {
        guard let viewModel = self.viewModel as? LetterViewModel else { return nil }
        let input = LetterViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            segmentControlValueChanged: self.segmentValueSubject,
            refresh: self.refreshSubject,
            sendLetterButtonDidTap: self.letterView.sendButtonTapPublisher,
            reportButtonDidTap: self.reportSubject
        )

        return viewModel.transform(from: input)
    }

    private func bindOutputToViewModel(_ output: LetterViewModel.Output?) {
        guard let output else { return }

        output.messages
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let items):
                    self?.handleMessageList(items)
                case .failure(let error):
                    self?.showErrorAlert(error.localizedDescription)
                    self?.handleMessageList([])
                }
            })
            .store(in: &self.cancelBag)

        output.messageDetails
            .sink(receiveValue: { [weak self] detail in
                self?.presentSendLetterViewController(detail: detail)
            })
            .store(in: &self.cancelBag)

        output.reportDetails
            .sink(receiveValue: { [weak self] details in
                let content = TextLiteral.Mail.reportMessage.localized(with: details.nickname, 
                                                                       details.content,
                                                                       Date().description)
                self?.sendReportMail(content: content)
            })
            .store(in: &self.cancelBag)

        Publishers.CombineLatest(output.roomStatus, output.index)
            .map { (state: $0, index: $1) }
            .sink(receiveValue: { [weak self] result in
                self?.updateLetterViewBottomArea(with: result.state, result.index)
            })
            .store(in: &self.cancelBag)
    }

    private func bindCell(_ cell: LetterCollectionViewCell, with item: MessageListItem) {
        cell.reportButtonTapPublisher
            .sink(receiveValue: { [weak self] content in
                if let content {
                    self?.reportSubject.send(content)
                } else {
                    self?.reportSubject.send(TextLiteral.Letter.emailEmptyContent.localized())
                }
            })
            .store(in: &self.cancelBag)

        cell.imageViewTapGesturePublisher
            .sink(receiveValue: { [weak self] _ in
                guard let imageUrl = item.imageUrl else { return }
                let viewController = LetterImageViewController(imageUrl: imageUrl)
                viewController.modalPresentationStyle = .fullScreen
                viewController.modalTransitionStyle = .crossDissolve
                self?.present(viewController, animated: true)
            })
            .store(in: &self.cancelBag)
    }

    private func bindHeaderView(_ headerView: LetterHeaderView) {
        headerView.segmentedControlTapPublisher
            .sink(receiveValue: { [weak self] value in
                self?.segmentValueSubject.send(value)
            })
            .store(in: &self.cancelBag)

        self.viewModelOutput?.index
            .sink(receiveValue: { [weak self] index in
                self?.updateLetterViewEmptyArea(with: index)
                headerView.setupHeaderSelectedIndex(at: index)
            })
            .store(in: &self.cancelBag)
    }
}

// MARK: - Helper
extension LetterViewController {
    private func showErrorAlert(_ message: String) {
        self.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                       message: message)
    }

    private func handleMessageList(_ messages: [MessageListItem]) {
        self.reloadMessageList(messages)
        self.letterView.updateEmptyAreaStatus(to: !messages.isEmpty)
    }
    
    private func sendReportMail(content: String) {
        let title = TextLiteral.Mail.reportTitle.localized()
        self.mailManager.sendMail(title: title, content: content)
    }

    private func updateLetterViewEmptyArea(with index: Int) {
        switch index {
        case 0:
            self.letterView.updateEmptyArea(with: TextLiteral.Letter.emptyToContent.localized())
        default:
            self.letterView.updateEmptyArea(with: TextLiteral.Letter.emptyFromContent.localized())
        }
    }

    private func updateLetterViewBottomArea(with state: RoomStatus, _ index: Int) {
        switch (state, index) {
        case (.PROCESSING, 0):
            self.letterView.showBottomArea()
        default:
            self.letterView.hideBottomArea()
        }
    }
    
    private func presentSendLetterViewController(detail: MessageDetail) {
        let usecase = SendLetterUsecaseImpl(repository: LetterRepositoryImpl())
        let viewModel = SendLetterViewModel(usecase: usecase,
                                            mission: detail.mission,
                                            manitteeId: detail.manitteeId,
                                            roomId: detail.roomId,
                                            missionId: detail.missionId)
        let viewController = SendLetterViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.configureDelegation(self)
        self.present(navigationController, animated: true)
    }
}

// MARK: - DataSource
extension LetterViewController {
    private func configureDataSource() {
        self.dataSource = self.letterCollectionViewDataSource()
        self.dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            return self?.dataSourceSupplementaryView(collectionView: collectionView,
                                                     kind: kind,
                                                     indexPath: indexPath)
        }

        self.configureSnapshot()
    }

    private func letterCollectionViewDataSource() -> UICollectionViewDiffableDataSource<Section, MessageListItem> {
        let letterCellRegistration = UICollectionView.CellRegistration<LetterCollectionViewCell, MessageListItem> {
            [weak self] cell, indexPath, item in
            cell.configureCell((mission: item.mission,
                                content: item.content,
                                imageURL: item.imageUrl,
                                isTodayLetter: item.isToday,
                                canReport: item.canReport))
            self?.bindCell(cell, with: item)
        }

        return UICollectionViewDiffableDataSource(
            collectionView: self.letterView.collectionView(),
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: letterCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
    }

    private func dataSourceSupplementaryView(collectionView: UICollectionView,
                                             kind: String,
                                             indexPath: IndexPath) -> UICollectionReusableView? {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LetterHeaderView.className,
                for: indexPath
            ) as? LetterHeaderView else { return UICollectionReusableView() }
            self.bindHeaderView(headerView)
            return headerView
        default:
            return nil
        }
    }
}

// MARK: - Snapshot
extension LetterViewController {
    private func configureSnapshot() {
        self.snapShot = NSDiffableDataSourceSnapshot<Section, MessageListItem>()
        self.snapShot.appendSections([.main])
        self.dataSource.apply(self.snapShot, animatingDifferences: true)
    }

    private func reloadMessageList(_ items: [MessageListItem]) {
        let previousMessageData = self.snapShot.itemIdentifiers(inSection: .main)
        self.snapShot.deleteItems(previousMessageData)
        self.snapShot.appendItems(items, toSection: .main)
        self.dataSource.apply(self.snapShot, animatingDifferences: true)
    }
}

// MARK: - SendLetterViewControllerDelegate
extension LetterViewController: SendLetterViewControllerDelegate {
    func refreshLetterData() {
        self.refreshSubject.send(())
    }
}
