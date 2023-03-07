//
//  LetterView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/07.
//

import UIKit

import SnapKit

final class LetterView: UIView {

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

    // MARK: - property


    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupButtonAction()
//        self.reloadCollectionView(with: self.letterState)
//        self.setupEmptyLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        // TODO: - 진행중일때만 하단 버튼이 나오도록
//        if self.roomState != "POST" {
//            self.addSubview(self.sendLetterView)
//            self.sendLetterView.snp.makeConstraints {
//                $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
//            }
//        }
    }



    private func setupEmptyView() {
//        self.emptyLabel.isHidden = !self.letterList.isEmpty
    }

    private func setupButtonAction() {
        let presentSendButtonAction = UIAction { [weak self] _ in
            guard let self = self,
                  let manitteeId = self.manitteeId
            else { return }

            let viewController = CreateLetterViewController(manitteeId: manitteeId, roomId: self.roomId, mission: self.mission, missionId: self.missionId)
            let navigationController = UINavigationController(rootViewController: viewController)
            viewController.succeedInSendingLetter = { [weak self] in
                guard let roomId = self?.roomId else { return }
                self?.fetchSendLetter(roomId: roomId)
            }
            self.present(navigationController, animated: true, completion: nil)
        }
        self.sendLetterView.addAction(presentSendButtonAction)
    }

    private func calculateContentHeight(text: String) -> CGFloat {
        let width = UIScreen.main.bounds.size.width - Size.leadingTrailingPadding * 2 - InternalSize.cellInset.left * 2
        let label = UILabel(frame: CGRect(origin: .zero,
                                          size: CGSize(width: width,
                                                       height: .greatestFiniteMagnitude)))
        label.text = text
        label.font = .font(.regular, ofSize: 15)
        label.numberOfLines = 0
        label.addLabelSpacing()
        label.sizeToFit()
        return label.frame.height
    }

    func setupLargeTitle(_ navigationController: UINavigationController) {
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .automatic
    }

    func reloadCollectionView(with state: LetterState) {
        let isReceivedState = (state == .received)
        let bottomInset: CGFloat = (isReceivedState ? 0 : 73)
        let topPoint = self.listCollectionView.adjustedContentInset.top + 1

        self.sendLetterView.isHidden = isReceivedState
        self.listCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        self.listCollectionView.setContentOffset(CGPoint(x: 0, y: -topPoint), animated: false)
        self.listCollectionView.collectionViewLayout.invalidateLayout()

        switch state {
        case .sent:
            self.fetchSendLetter(roomId: self.roomId)
        case .received:
            self.fetchReceviedLetter(roomId: self.roomId)
        }
    }

    func setupEmptyLabel(_ text: String) {
        self.emptyLabel.text = text
        self.emptyLabel.isHidden = true
    }

    func updateLetterView() {
        self.listCollectionView.reloadData()
        self.setupEmptyView()
    }

    func configureDelegation(_ delegate: UICollectionViewDataSource) {
        self.listCollectionView.delegate = self
        self.listCollectionView.dataSource = delegate
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
