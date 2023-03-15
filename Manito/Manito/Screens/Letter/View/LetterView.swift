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
}

final class LetterView: UIView {

    enum LetterType {
        case sent, received

        var bottomContentInset: CGFloat { return self == .received ? 0 : 73 }
        var isHiddenBottomArea: Bool { return self == .received }
        var emptyText: String {
            switch self {
            case .sent: return TextLiteral.letterViewControllerEmptyViewTo
            case .received: return TextLiteral.letterViewControllerEmptyViewFrom
            }
        }
    }

    private enum InternalSize {
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - Size.leadingTrailingPadding * 2
        static let headerHeight: CGFloat = 66.0
        static let imageHeight: CGFloat = 204.0
        static let cellInset: UIEdgeInsets = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 22.0, right: 16.0)
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
            self.fetchSendLetter(roomId: self.roomId)
            self.listCollectionView.reloadData()
        case .received:
            self.fetchReceviedLetter(roomId: self.roomId)
            self.listCollectionView.reloadData()
        }
    }

    private func calculateContentHeight(text: String) -> CGFloat {
        let width = UIScreen.main.bounds.size.width - Size.leadingTrailingPadding * 2 - InternalSize.cellInset.left * 2
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: width, height: .greatestFiniteMagnitude)))
        label.text = text
        label.font = .font(.regular, ofSize: 15)
        label.numberOfLines = 0
        label.addLabelSpacing()
        label.sizeToFit()
        return label.frame.height
    }

    func configureDelegation(_ delegate: UICollectionViewDataSource & LetterViewDelegate) {
        self.delegate = delegate
        self.listCollectionView.delegate = self
        self.listCollectionView.dataSource = delegate
    }

    func configureNavigationController(_ viewController: UIViewController) {
        self.setupNavigationTitle(in: viewController)
        self.setupGuideView(in: viewController)
    }

    func configureBottomArea() {
        self.setupBottomOfSendLetterView()
    }

    func updateLetterView(to type: LetterType) {
        self.updateEmptyLabel(to: type.emptyText)
        self.updateListCollectionViewConfiguration(to: type)
        self.updateLetter(to: type)
    }

    func updateLetterViewEmptyState(isHidden: Bool) {
        self.emptyLabel.isHidden = isHidden
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LetterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heights = [InternalSize.cellInset.top, InternalSize.cellInset.bottom]

//        // TODO: - calculate 하는건 어디에...
//        if let content = self.letterList[indexPath.item].content {
//            heights += [self.calculateContentHeight(text: content)]
//        }
//
//        if let mission = self.letterList[indexPath.item].mission {
//            heights += [self.calculateContentHeight(text: mission) + 10]
//        } else {
//            let date = self.letterList[indexPath.item].date
//            heights += [self.calculateContentHeight(text: date) + 5]
//        }
//
//        if self.letterList[indexPath.item].imageUrl != nil {
//            heights += [InternalSize.imageHeight]
//        }

        return CGSize(width: InternalSize.cellWidth, height: heights.reduce(0, +))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: InternalSize.headerHeight)
    }
}

// TODO: - 일단 Guide 부터 어떻게 해봐야겠다 진짜..ㅎ
// MARK: - UICollectionViewDelegate
//extension LetterView: UICollectionViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.guideBoxImageView.isHidden = true
//    }
//}
