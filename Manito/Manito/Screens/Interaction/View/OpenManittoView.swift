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

    func animateManittoCollectionView(with friendList: FriendList) {
        guard let count = self.friendsList.count else { return }
        let timeInterval: Double = 0.3
        let durationTime: Double = timeInterval * Double(count)
        let delay: Double = 1.0

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.animate(withDuration: durationTime, animations: {
                self.setRandomAnimationTimer(withTimeInterval: timeInterval)
            }, completion: { _ in
                self.setManittoAnimation(with: .now() + delay + durationTime)
            })
        })
    }

    private func setRandomAnimationTimer(withTimeInterval timeInterval: TimeInterval) {
        var countNumber = 0

        // friend list, randomIndex
//        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
//            guard let self = self,
//                  let count = self.friendsList.count,
//                  countNumber != self.friendsList.count else { return }
//            let characterCount = count - 1
//
//            self.randomIndex = Int.random(in: 0...characterCount, excluding: self.manittoRandomIndex)
//            countNumber += 1
//        }
    }

    private func setManittoAnimation(with deadline: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            // manittoIndex
//            self.randomIndex = self.manittoIndex
        })

        DispatchQueue.main.asyncAfter(deadline: deadline + 1.0, execute: {
            // 팝업 화면 띄우기 구현
//            self.presentPopupViewController()
        })
    }

}
