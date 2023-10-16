//
//  LetterView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/07.
//

import Combine
import UIKit

import SnapKit

final class LetterView: UIView, BaseViewType {

    private enum ConstantSize {
        static let headerWidth: CGFloat = UIScreen.main.bounds.size.width
        static let headerHeight: CGFloat = 66.0
        static let groupInterItemSpacing: CGFloat = 33
        static let headerContentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets.zero
        static let sectionContentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 18.0,
            leading: SizeLiteral.leadingTrailingPadding,
            bottom: 18.0,
            trailing: SizeLiteral.leadingTrailingPadding
        )
        static let stackMargins: UIEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 18,
            right: 0
        )
    }

    // MARK: - ui component

    private let guideView: GuideView = GuideView(type: .letter)
    private let wholeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.layoutMargins = ConstantSize.stackMargins
        return stackView
    }()
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGrey
        return view
    }()
    private let sendLetterButton: UIButton = {
        let button = MainButton()
        button.title = TextLiteral.Letter.buttonSend.localized()
        return button
    }()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .font(.regular, ofSize: 16)
        label.text = TextLiteral.Letter.emptyToContent.localized()
        label.isHidden = true
        label.textColor = .grey003
        label.addLabelSpacing(lineSpacing: 16)
        label.textAlignment = .center
        return label
    }()
    private lazy var listCollectionView: UICollectionView = {
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

    // MARK: - property

    var sendButtonTapPublisher: AnyPublisher<Void, Never> {
        return self.sendLetterButton.tapPublisher
    }

    private var cancelBag: Set<AnyCancellable> = Set()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.bindUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func

    func configureNavigationBar(of viewController: UIViewController) {
        self.setupNavigationTitle(in: viewController)
        self.setupGuideView(in: viewController)
    }

    func updateEmptyAreaStatus(to isHidden: Bool) {
        self.emptyLabel.isHidden = isHidden
    }

    func updateEmptyArea(with text: String) {
        self.emptyLabel.text = text
    }

    func showBottomArea() {
        self.bottomView.isHidden = false
        self.wholeStackView.isLayoutMarginsRelativeArrangement = true
    }

    func hideBottomArea() {
        self.bottomView.isHidden = true
        self.wholeStackView.isLayoutMarginsRelativeArrangement = false
    }

    func removeGuideView() {
        self.guideView.removeGuideView()
    }

    func collectionView() -> UICollectionView {
        return self.listCollectionView
    }
}

extension LetterView {

    // MARK: - base func

    func setupLayout() {
        self.addSubview(self.wholeStackView)
        self.wholeStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.addSubview(self.emptyLabel)
        self.emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        self.wholeStackView.addArrangedSubview(self.listCollectionView)
        self.wholeStackView.addArrangedSubview(self.bottomView)
        self.bottomView.snp.makeConstraints {
            $0.height.equalTo(73)
        }

        self.bottomView.addSubview(self.sendLetterButton)
        self.sendLetterButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.centerX.equalToSuperview()
        }
    }

    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }

    // MARK: - Private - func

    private func bindUI() {
        self.listCollectionView.scrollPublisher
            .sink(receiveValue: { [weak self] in
                self?.guideView.hideGuideView()
            })
            .store(in: &self.cancelBag)
    }

    private func setupNavigationTitle(in viewController: UIViewController) {
        guard let navigationController = viewController.navigationController else { return }
        viewController.title = TextLiteral.Letter.title.localized()
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
        let layout = UICollectionViewCompositionalLayout { [weak self] index, environment -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(500)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(300)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = ConstantSize.sectionContentInset
            section.boundarySupplementaryItems = self?.sectionHeader() ?? []
            section.interGroupSpacing = ConstantSize.groupInterItemSpacing

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
