//
//  LetterView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/07.
//

import UIKit

import SnapKit

protocol LetterViewDelegate: AnyObject {
    func presentCreateLetterViewController()
    func fetchSendLetter()
    func fetchReceivedLetter()
}

final class LetterView: UIView {

    enum LetterType: Int {
        case sent = 0, received = 1

        var bottomContentInset: CGFloat { return self == .received ? 0 : 73 }
        var isHiddenBottomArea: Bool { return self == .received }
        var emptyText: String {
            switch self {
            case .sent: return TextLiteral.letterViewControllerEmptyViewTo
            case .received: return TextLiteral.letterViewControllerEmptyViewFrom
            }
        }

        static subscript(index: Int) -> Self {
            return LetterType(rawValue: index) ?? .sent
        }
    }

    private enum InternalSize {
        static let headerHeight: CGFloat = 66.0
        static let collectionInset: UIEdgeInsets = UIEdgeInsets(top: 18.0,
                                                                left: Size.leadingTrailingPadding,
                                                                bottom: 18.0,
                                                                right: Size.leadingTrailingPadding)
    }

    // MARK: - ui component

    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = InternalSize.collectionInset
        flowLayout.minimumLineSpacing = 33
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width,
                                                height: InternalSize.headerHeight)
        return flowLayout
    }()
    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cell: LetterCollectionViewCell.self,
                                forCellWithReuseIdentifier: LetterCollectionViewCell.className)
        collectionView.register(LetterHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: LetterHeaderView.className)
        return collectionView
    }()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .font(.regular, ofSize: 16)
        label.text = TextLiteral.letterViewControllerEmptyViewTo
        label.isHidden = true
        label.textColor = .grey003
        label.textAlignment = .center
        label.addLabelSpacing(lineSpacing: 16)
        return label
    }()
    private lazy var sendLetterView: BottomOfSendLetterView = BottomOfSendLetterView()
    private let guideView: GuideView = GuideView(type: .letter)

    // MARK: - property

    private weak var delegate: LetterViewDelegate?
    private(set) var letterType: LetterType = .sent {
        willSet(type) {
            self.updateLetterView(to: type)
        }
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupButtonAction()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.guideView.setupDisappearedConfiguration()
    }

    // MARK: - func

    private func setupLayout() {
        self.addSubview(self.listCollectionView)
        self.listCollectionView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }

        self.addSubview(self.emptyLabel)
        self.emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func setupBottomOfSendLetterView() {
        self.addSubview(self.sendLetterView)
        self.sendLetterView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }

    private func setupButtonAction() {
        let presentCreateLetterAction = UIAction { [weak self] _ in
            self?.delegate?.presentCreateLetterViewController()
        }
        self.sendLetterView.addAction(presentCreateLetterAction)
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

    private func updateLetterView(to type: LetterType) {
        self.updateEmptyLabel(to: type.emptyText)
        self.updateListCollectionViewConfiguration(to: type)
        self.updateLetter(to: type)
    }

    private func updateEmptyLabel(to text: String) {
        self.emptyLabel.text = text
    }

    private func updateListCollectionViewConfiguration(to type: LetterType) {
        let bottomInset: CGFloat = type.bottomContentInset
        let yPoint = self.listCollectionView.adjustedContentInset.top + 1

        self.sendLetterView.isHidden = type.isHiddenBottomArea
        self.listCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        self.listCollectionView.setContentOffset(CGPoint(x: 0, y: -yPoint), animated: false)
        self.listCollectionView.collectionViewLayout.invalidateLayout()
    }

    private func updateLetter(to type: LetterType) {
        switch type {
        case .sent:
            self.delegate?.fetchSendLetter()
        case .received:
            self.delegate?.fetchReceivedLetter()
        }
    }

    func configureDelegation(_ delegate: UICollectionViewDataSource & UICollectionViewDelegate & LetterViewDelegate) {
        self.listCollectionView.delegate = delegate
        self.listCollectionView.dataSource = delegate
        self.delegate = delegate
    }

    func configureNavigationController(_ viewController: UIViewController) {
        self.setupNavigationTitle(in: viewController)
        self.setupGuideView(in: viewController)
    }

    func configureBottomArea() {
        self.setupBottomOfSendLetterView()
    }

    func updateLetterType(to type: LetterType) {
        self.letterType = type
    }

    func updateLetterViewEmptyState(isHidden: Bool) {
        self.emptyLabel.isHidden = isHidden
    }

    func reloadCollectionViewData() {
        self.listCollectionView.reloadData()
    }

    func scrollViewDidEndDraggingConfiguration() {
        self.guideView.setupDisappearedConfiguration()
    }
}
