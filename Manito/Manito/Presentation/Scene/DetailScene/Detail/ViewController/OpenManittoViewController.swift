//
//  OpenManittoViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import Combine
import UIKit

import SnapKit

final class OpenManittoViewController: UIViewController, Navigationable {

    // MARK: - ui component

    private let openManittoView: OpenManittoView = OpenManittoView()

    // MARK: - property
    
    private var memberList: [MemberInfo] = []
    private var randomIndex: Int = 0
    
    private var cancelBag: Set<AnyCancellable> = Set()
    
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
        self.view = self.openManittoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
        self.bindViewModel()
        self.setupNavigation()
    }

    // MARK: - func

    private func configureDelegation() {
        self.openManittoView.configureDelegation(self)
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }

    private func transformedOutput() -> OpenManittoViewModel.Output? {
        guard let viewModel = self.viewModel as? OpenManittoViewModel else { return nil }
        let input = OpenManittoViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            openManitto: <#T##AnyPublisher<Void, Never>#>
        )
        return viewModel.transform(from: input)
    }

    private func bindOutputToViewModel(_ output: OpenManittoViewModel.Output?) {
        guard let output = output else { return }
        
        output.memberInfo
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let list):
                    self?.memberList = list
                    self?.openManittoView.setupManittoAnimation(friendList: list,
                                                               manittoIndex: manittoIndex,
                                                               manittoNickname: self.manittoNickname)
                case .failure(let error):
                    self?.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                                   message: error.localizedDescription)
                    self?.dismiss(animated: true)
                }
            })
            .store(in: &self.cancelBag)
    }
}

// MARK: - UICollectionViewDataSource
extension OpenManittoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OpenManittoCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let member = self.memberList[indexPath.item]
        cell.configureCell(colorIndex: member.colorIndex)

        if indexPath.item == self.randomIndex {
            cell.highlightCell()
        }

        return cell
    }
}

// MARK: - OpenManittoViewDelegate
extension OpenManittoViewController: OpenManittoViewDelegate {
    func confirmButtonTapped() {
        self.dismiss(animated: true)
    }
}
