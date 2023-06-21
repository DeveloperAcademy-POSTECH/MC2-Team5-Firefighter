//
//  LetterView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/07.
//

import UIKit

import SnapKit

final class LetterView: UIView {

    enum RoomState: String {
        case PROCESSING
        case POST
    }

    enum MessageType: Int {
        case sent = 0
        case received = 1

        var bottomContentInset: CGFloat { return self == .received ? 0 : 73 }
        var isHiddenBottomArea: Bool { return self == .received }
        var emptyText: String {
            switch self {
            case .sent: return TextLiteral.letterViewControllerEmptyViewTo
            case .received: return TextLiteral.letterViewControllerEmptyViewFrom
            }
        }
    }

    private enum ConstantSize {
        static let headerHeight: CGFloat = 66.0
        static let imageHeight: CGFloat = 204.0
        static let cellInset: UIEdgeInsets = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 22.0, right: 16.0)
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - Size.leadingTrailingPadding * 2
        static let collectionInset: UIEdgeInsets = UIEdgeInsets(top: 18.0,
                                                                left: Size.leadingTrailingPadding,
                                                                bottom: 18.0,
                                                                right: Size.leadingTrailingPadding)
    }

    // MARK: - ui component

    private let guideView: GuideView = GuideView(type: .letter)
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGrey
        return view
    }()
    private let listCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = ConstantSize.collectionInset
        flowLayout.minimumLineSpacing = 33
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width,
                                                height: ConstantSize.headerHeight)
        return flowLayout
    }()

    lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.listCollectionViewFlowLayout)
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
        label.textAlignment = .center
        label.addLabelSpacing(lineSpacing: 16)
        return label
    }()
    let headerView: LetterHeaderView = LetterHeaderView()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.hideGuideView()
    }

    // MARK: - func

    // TODO: - roomstate를 public한 enum으로 변경할 것
    func configureLayout(with state: RoomState) {
        self.setupLayout()

        if state == .PROCESSING {
            self.setupBottomViewLayout()
        }
    }

    func configureNavigationBar(of viewController: UIViewController) {
        self.setupNavigationTitle(in: viewController)
        self.setupGuideView(in: viewController)
    }

    func hideGuideView() {
        self.guideView.setupDisappearedConfiguration()
    }

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

    private func setupBottomViewLayout() {
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

//    private func updateLetterView(to type: LetterType) {
//        self.updateEmptyLabel(to: type.emptyText)
//        self.updateListCollectionViewConfiguration(to: type)
//        self.updateLetter(to: type)
//    }
//
//    private func updateEmptyLabel(to text: String) {
//        self.emptyLabel.text = text
//    }
//
//    private func updateListCollectionViewConfiguration(to type: LetterType) {
//        let bottomInset: CGFloat = type.bottomContentInset
//        let yPoint = self.listCollectionView.adjustedContentInset.top + 1
//
//        self.bottomView.isHidden = type.isHiddenBottomArea
//        self.listCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
//        self.listCollectionView.setContentOffset(CGPoint(x: 0, y: -yPoint), animated: false)
//        self.listCollectionView.collectionViewLayout.invalidateLayout()
//    }
}

// MARK: - UICollectionViewDelegateFlowLayout
//extension LetterView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var heights = [ConstantSize.cellInset.top, ConstantSize.cellInset.bottom]
//
//        if let content = self.letterList[indexPath.item].content {
//            heights += [self.calculateCellContentViewHeight(by: content)]
//        }
//
//        if let mission = self.letterList[indexPath.item].mission {
//            heights += [self.calculateCellContentViewHeight(by: mission) + 10]
//        } else {
//            let date = self.letterList[indexPath.item].date
//            heights += [self.calculateCellContentViewHeight(by: date) + 5]
//        }
//
//        if self.letterList[indexPath.item].imageUrl != nil {
//            heights += [ConstantSize.imageHeight]
//        }
//
//        return CGSize(width: ConstantSize.cellWidth, height: heights.reduce(0, +))
//    }
//
//    private func calculateCellContentViewHeight(by text: String) -> CGFloat {
//        let width = UIScreen.main.bounds.size.width - Size.leadingTrailingPadding * 2 - ConstantSize.cellInset.left * 2
//        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: width, height: .greatestFiniteMagnitude)))
//        label.text = text
//        label.font = .font(.regular, ofSize: 15)
//        label.numberOfLines = 0
//        label.addLabelSpacing()
//        label.sizeToFit()
//        return label.frame.height
//    }
//}

// MARK: - UICollectionViewDelegate
//extension LetterView: UICollectionViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.hideGuideView()
//    }
//}
