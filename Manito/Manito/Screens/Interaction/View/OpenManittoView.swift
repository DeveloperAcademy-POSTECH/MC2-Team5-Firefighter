//
//  OpenManittoView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/27.
//

import UIKit

import SnapKit

final class OpenManittoView: UIView {

    private enum InternalSize {
        static let collectionHorizontalSpacing: CGFloat = 29.0
        static let collectionVerticalSpacing: CGFloat = 37.0
        static let cellLineSpacing: CGFloat = 20.0
        static let cellInteritemSpacing: CGFloat = 39.0
        static let cellItemSize: CGFloat = floor((UIScreen.main.bounds.size.width - (collectionHorizontalSpacing * 2 + cellInteritemSpacing * 2)) / 3)
        static let collectionSectionInset = UIEdgeInsets(top: collectionVerticalSpacing,
                                                         left: collectionHorizontalSpacing,
                                                         bottom: collectionVerticalSpacing,
                                                         right: collectionHorizontalSpacing)
    }

    // MARK: - ui component

    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = InternalSize.collectionSectionInset
        flowLayout.minimumLineSpacing = InternalSize.cellLineSpacing
        flowLayout.minimumInteritemSpacing = InternalSize.cellInteritemSpacing
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.itemSize = CGSize(width: InternalSize.cellItemSize, height: InternalSize.cellItemSize)
        return flowLayout
    }()
    private lazy var manittoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(cell: ManittoCollectionViewCell.self,
                                forCellWithReuseIdentifier: ManittoCollectionViewCell.className)
        return collectionView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 34)
        label.text = TextLiteral.openManittoViewControllerTitle
        return label
    }()

    // MARK: - property

    private let totalCount = 10.0
    private var randomIndex = -1 {
        didSet {
            self.manittoCollectionView.reloadData()
        }
    }

    // MARK: - func

    private func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(57)
            $0.leading.equalToSuperview().inset(16)
        }

        self.addSubview(self.manittoCollectionView)
        self.manittoCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }

    private func setRandomAnimationTimer(with timeInterval: TimeInterval, _ friendList: FriendList) {
        guard let count = friendList.count else { return }
        var countNumber = 0

        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            defer { countNumber += 1 }
            guard let self = self,
                  countNumber != Int(self.totalCount) else { return }

            self.randomIndex = Int.random(in: 0...count-1, excluding: self.randomIndex)
        }
    }

    private func setManittoAnimation(with deadline: DispatchTime, _ manittoIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            self.randomIndex = manittoIndex
        })

        DispatchQueue.main.asyncAfter(deadline: deadline + 1.0, execute: {
//            self.presentPopupViewController()
        })
    }

    func animateManittoCollectionView(with friendList: FriendList, _ manittoIndex: Int) {
        let timeInterval: Double = 0.3
        let durationTime: Double = timeInterval * self.totalCount
        let delay: Double = 1.0

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.animate(withDuration: durationTime, animations: {
                self.setRandomAnimationTimer(with: timeInterval, friendList)
            }, completion: { _ in
                let deadline: DispatchTime = .now() + delay + durationTime
                self.setManittoAnimation(with: deadline, manittoIndex)
            })
        })
    }
}
