//
//  FriendListViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/19/23.
//

import Combine
import UIKit

final class FriendListViewController: UIViewController, Navigationable {
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - ui component
    
    private let friendListView: FriendListView = FriendListView()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, MemberInfo>?
    private var snapShot: NSDiffableDataSourceSnapshot<Section, MemberInfo>?

    // MARK: - property
    
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
        self.view = self.friendListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.configureNavigationBar()
        self.configureDataSource()
        self.bindViewModel()
    }
    
    // MARK: - func
    
    private func configureNavigationBar() {
        self.friendListView.configureNavigationBar(self)
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }

    private func transformedOutput() -> FriendListViewModel.Output? {
        guard let viewModel = self.viewModel as? FriendListViewModel else { return nil }
        let input = FriendListViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher
        )
        return viewModel.transform(from: input)
    }

    private func bindOutputToViewModel(_ output: FriendListViewModel.Output?) {
        guard let output = output else { return }

        output.friendList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.reloadMemberList(data)
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            })
            .store(in: &self.cancelBag)
    }
    
    private func showErrorAlert(title: String = TextLiteral.Common.Error.title.localized(),
                                message: String) {
        self.makeAlert(title: title, message: message)
    }
}

// MARK: - DataSource
extension FriendListViewController {
    private func configureDataSource() {
        self.dataSource = self.friendListCollectionViewDataSource()
        self.configureSnapshot()
    }
    
    private func friendListCollectionViewDataSource() -> UICollectionViewDiffableDataSource<Section, MemberInfo> {
        let friendCellRegistration = UICollectionView.CellRegistration<FriendCollectionViewCell, MemberInfo> { cell, indexPath, item in
            cell.configureCell(name: item.nickname,
                               colorIndex: item.colorIndex)
        }
        
        return UICollectionViewDiffableDataSource(
            collectionView: self.friendListView.collectionView(),
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: friendCellRegistration,
                    for: indexPath,
                    item: item)
            }
        )
    }
}

// MARK: - Snapshot
extension FriendListViewController {
    private func configureSnapshot() {
        self.snapShot = NSDiffableDataSourceSnapshot<Section, MemberInfo>()
        self.snapShot?.appendSections([.main])
        if let snapShot {
            self.dataSource?.apply(snapShot, animatingDifferences: true)
        }
    }
    
    private func reloadMemberList(_ items: [MemberInfo]) {
        guard var snapShot else { return }
        let previousMemberData = snapShot.itemIdentifiers(inSection: .main)
        snapShot.deleteItems(previousMemberData)
        snapShot.appendItems(items, toSection: .main)
        self.dataSource?.apply(snapShot, animatingDifferences: true)
    }
}
