//
//  LetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import Combine
import UIKit

final class LetterViewController: BaseViewController {

    // MARK: - ui component

    private let letterView: LetterView = LetterView()

    private var dataSource: CollectionViewDataSource<LetterCollectionViewCell, Message>!

    // MARK: - property

    private let reportSubject: PassthroughSubject<String, Never> = PassthroughSubject()
    private let refreshSubject: PassthroughSubject<Void, Never> = PassthroughSubject()

    private var cancelBag: Set<AnyCancellable> = Set()

    private let viewModel: any ViewModelType
    private var roomState: LetterView.RoomState
    private var messageType: LetterView.MessageType


    // MARK: - init
    
    init(viewModel: any ViewModelType,
         roomState: LetterView.RoomState,
         messageType: LetterView.MessageType) {
        self.viewModel = viewModel
        self.roomState = roomState
        self.messageType = messageType
        super.init()
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
        self.bindViewModel()
    }

    // MARK: - override

    override func configureUI() {
        super.configureUI()
        self.letterView.configureLayout(with: self.roomState)
        self.letterView.configureNavigationBar(of: self)
    }

    // MARK: - func

    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }

    private func transformedOutput() -> LetterViewModel.Output? {
        guard let viewModel = self.viewModel as? LetterViewModel else { return nil }
        let input = LetterViewModel.Input(
            viewDidLoad:
                self.viewDidLoadPublisher
                    .withUnretained(self)
                    .map { owner, _ in owner.messageType.rawValue }
                    .map { LetterViewModel.MessageType(rawValue: $0)! }
                    .eraseToAnyPublisher(),
            segmentControlValueChanged:
                self.letterView.headerView.segmentedControlTapPublisher
                    .withUnretained(self)
                    .map { owner, _ -> LetterViewModel.MessageType in
                        guard let type = LetterViewModel.MessageType(rawValue: owner.messageType.rawValue) else { return .sent }
                        return type
                    }
                    .eraseToAnyPublisher(),
            refresh: self.refreshSubject,
            sendLetterButtonDidTap: self.letterView.sendLetterButton.tapPublisher,
            reportButtonDidTap: self.reportSubject
        )

        return viewModel.transform(from: input)
    }

    private func bindOutputToViewModel(_ output: LetterViewModel.Output?) {
        guard let output = output else { return }

        output.messages
            .withUnretained(self)
            .map { owner, items in
                owner.letterCollectionViewDataSource(items: items)
            }
            .catch { _ in return Just(nil)}
            .withUnretained(self)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { owner, dataSource in
                guard let dataSource = dataSource else {
                    owner.showErrorAlert()
                    return
                }

                owner.updateList(with: dataSource)
            })
            .store(in: &self.cancelBag)

        output.index
            .withUnretained(self)
            .sink(receiveValue: { owner, index in
                owner.letterView.headerView.setValue(index)
            })
            .store(in: &self.cancelBag)

        output.messageDetails
            .withUnretained(self)
            .sink(receiveValue: { owner, details in
                let viewController = CreateLetterViewController(manitteeId: details.manitteeId,
                                                                roomId: details.roomId,
                                                                mission: details.mission,
                                                                missionId: details.missionId)
                let navigationController = UINavigationController(rootViewController: viewController)
                viewController.configureDelegation(self)
                owner.present(navigationController, animated: true)
            })
            .store(in: &self.cancelBag)

        output.reportDetails
            .withUnretained(self)
            .sink(receiveValue: { owner, details in
                owner.sendReportMail(userNickname: details.nickname, content: details.content)
            })
            .store(in: &self.cancelBag)
    }
}

extension LetterViewController {
    private func letterCollectionViewDataSource(items: [Message]) -> CollectionViewDataSource<LetterCollectionViewCell, Message> {
        return CollectionViewDataSource(identifier: LetterCollectionViewCell.className,
                                        items: items) { cell, item in
            cell.configureCell((mission: item.mission,
                                date: item.date,
                                content: item.content,
                                imageURL: item.imageUrl,
                                isTodayLetter: item.isToday))
            self.bindCell(cell, with: item)
        }
    }

    private func bindCell(_ cell: LetterCollectionViewCell, with item: Message) {
        cell.reportButtonTapPublisher
            .withUnretained(self)
            .sink(receiveValue: { owner, _ in
                if let content = item.content {
                    owner.reportSubject.send(content)
                } else {
                    owner.reportSubject.send("쪽지 내용 없음")
                }
            })
            .store(in: &self.cancelBag)

        cell.imageViewTapGesturePublisher
            .withUnretained(self)
            .sink(receiveValue: { owner, _ in
                guard let imageUrl = item.imageUrl else { return }
                let viewController = LetterImageViewController(imageUrl: imageUrl)
                viewController.modalPresentationStyle = .fullScreen
                viewController.modalTransitionStyle = .crossDissolve
                owner.present(viewController, animated: true)
            })
            .store(in: &self.cancelBag)
    }

    private func showErrorAlert() {
        self.makeAlert(title: TextLiteral.letterViewControllerErrorTitle,
                       message: TextLiteral.letterViewControllerErrorDescription)
    }

    private func updateList(with dataSource: CollectionViewDataSource<LetterCollectionViewCell, Message>) {
        self.dataSource = dataSource
        self.letterView.listCollectionView.dataSource = dataSource
        self.letterView.listCollectionView.reloadData()
    }
}

extension LetterViewController: CreateLetterViewControllerDelegate {
    func refreshLetterData() {
        self.refreshSubject.send(())
    }
}

private extension CollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: LetterHeaderView.className,
            for: indexPath
        ) as? LetterHeaderView else { return UICollectionReusableView() }
        return headerView
    }
}
