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

    // MARK: - init
    
    init(viewModel: any ViewModelType) {
        self.viewModel = viewModel
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.letterView.removeGuideView()
    }

    // MARK: - override

    override func configureUI() {
        super.configureUI()
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
            viewDidLoad: self.viewDidLoadPublisher,
            segmentControlValueChanged:
                self.letterView.headerView.segmentedControlTapPublisher
                    .map { index -> LetterViewModel.MessageType in
                        guard let type = LetterViewModel.MessageType(rawValue: index) else { return .sent }
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
            .map { [weak self] items in
                self?.letterCollectionViewDataSource(items: items)
            }
            .catch { _ in return Just(nil)}
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] dataSource in
                guard let dataSource = dataSource else {
                    self?.showErrorAlert()
                    return
                }

                self?.updateList(with: dataSource)
                // TODO: - view layout update(데이터 없으면 empty 멘트)
            })
            .store(in: &self.cancelBag)

        output.messageDetails
            .sink(receiveValue: { [weak self] details in
                guard let self = self else { return }
                let viewController = CreateLetterViewController(manitteeId: details.manitteeId,
                                                                roomId: details.roomId,
                                                                mission: details.mission,
                                                                missionId: details.missionId)
                let navigationController = UINavigationController(rootViewController: viewController)
                viewController.configureDelegation(self)
                self.present(navigationController, animated: true)
            })
            .store(in: &self.cancelBag)

        output.reportDetails
            .sink(receiveValue: { [weak self] details in
                self?.sendReportMail(userNickname: details.nickname, content: details.content)
            })
            .store(in: &self.cancelBag)

        Publishers.CombineLatest(output.roomState, output.index)
            .map { (state: $0, index: $1) }
            .sink(receiveValue: { [weak self] result in
                switch (result.state, result.index) {
                case (.processing, 0):
                    self?.letterView.showBottomArea()
                default:
                    self?.letterView.hideBottomArea()
                }
                // TODO: - cell report 보이게 안보이게
                // TODO: - Empty Label Text
            })
            .store(in: &self.cancelBag)
    }
}

extension LetterViewController {
    private func letterCollectionViewDataSource(items: [Message]) -> CollectionViewDataSource<LetterCollectionViewCell, Message> {
        return CollectionViewDataSource(identifier: LetterCollectionViewCell.className,
                                        items: items) { [weak self] cell, item in
//            let canReport = self.messageType == .received
            cell.configureCell((mission: item.mission,
                                date: item.date,
                                content: item.content,
                                imageURL: item.imageUrl,
                                isTodayLetter: item.isToday,
                                canReport: true))
            self?.bindCell(cell, with: item)
        }
    }

    private func bindCell(_ cell: LetterCollectionViewCell, with item: Message) {
        cell.reportButtonTapPublisher
            .sink(receiveValue: { [weak self] _ in
                if let content = item.content {
                    self?.reportSubject.send(content)
                } else {
                    self?.reportSubject.send("쪽지 내용 없음")
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
