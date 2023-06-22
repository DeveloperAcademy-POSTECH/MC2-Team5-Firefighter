//
//  LetterView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/07.
//

import Combine
import UIKit

import SnapKit

final class LetterView: UIView {

    private enum ConstantSize {
        static let headerWidth: CGFloat = UIScreen.main.bounds.size.width
        static let headerHeight: CGFloat = 66.0
        static let groupInterItemSpacing: CGFloat = 33.0
        static let contentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 18.0,
            leading: Size.leadingTrailingPadding,
            bottom: 18.0,
            trailing: Size.leadingTrailingPadding
        )
        static let headerContentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets.zero
    }

    // MARK: - ui component

    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGrey
        return view
    }()
    private let guideView: GuideView = GuideView(type: .letter)

    lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cell: LetterCollectionViewCell.self,
                                forCellWithReuseIdentifier: LetterCollectionViewCell.className)
        collectionView.register(LetterHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: LetterHeaderView.className)
        return collectionView
    }()
    lazy var sendLetterButton: UIButton = {
        let button = MainButton()
        button.title = TextLiteral.sendLetterViewSendLetterButton
        return button
    }()
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .font(.regular, ofSize: 16)
        label.text = TextLiteral.letterViewControllerEmptyViewTo
        label.isHidden = true
        label.textColor = .grey003
        label.addLabelSpacing(lineSpacing: 16)
        label.textAlignment = .center
        return label
    }()

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.bindUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.removeGuideView()
    }

    // MARK: - func

    func configureNavigationBar(of viewController: UIViewController) {
        self.setupNavigationTitle(in: viewController)
        self.setupGuideView(in: viewController)
    }

    func updateEmptyArea(with items: [Message]) {
        let isEmpty = items.isEmpty
        self.emptyLabel.isHidden = !isEmpty
    }

    func updateEmptyArea(with text: String) {
        self.emptyLabel.text = text
    }

    func showBottomArea() {
        self.bottomView.isHidden = false
    }

    func hideBottomArea() {
        self.bottomView.isHidden = true
    }

    func removeGuideView() {
        self.guideView.removeGuideView()
    }
}

extension LetterView {
    private func setupLayout() {
        self.addSubview(self.listCollectionView)
        self.listCollectionView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }

        self.addSubview(self.emptyLabel)
        self.emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        self.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(73)
        }

        self.bottomView.addSubview(self.sendLetterButton)
        self.sendLetterButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.centerX.equalToSuperview()
        }
    }

    private func bindUI() {
        self.listCollectionView.scrollPublisher
            .sink(receiveValue: { [weak self] in
                self?.guideView.hideGuideView()
            })
            .store(in: &self.cancelBag)
    }

    private func setupNavigationTitle(in viewController: UIViewController) {
        guard let navigationController = viewController.navigationController else { return }
        viewController.title = TextLiteral.letterViewControllerTitle
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .automatic
    }

    private func setupGuideView(in viewController: UIViewController) {
        guard let navigationController = viewController.navigationController else { return }
        self.guideView.setupGuideViewLayout(in: navigationController)
        self.guideView.addGuideButton(in: viewController.navigationItem)
        self.guideView.hideGuideViewWhenTappedAround(in: navigationController, viewController)
    }
}

// MARK: - UICollectionViewLayout
extension LetterView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { index, environment -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(ConstantSize.groupInterItemSpacing)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = ConstantSize.contentInset
            section.boundarySupplementaryItems = self.sectionHeader()
            return section
        }

        return layout
    }

    private func sectionHeader() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .absolute(ConstantSize.headerWidth),
            heightDimension: .absolute(ConstantSize.headerHeight)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = ConstantSize.headerContentInset
        header.pinToVisibleBounds = true
        return [header]
    }
}
