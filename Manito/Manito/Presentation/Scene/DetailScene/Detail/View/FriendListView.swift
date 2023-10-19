//
//  FriendListView.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/19/23.
//

import UIKit

import SnapKit

final class FriendListView: UIView, BaseViewType {
    
    private enum ConstantSize {
        static let groupInterItemSpacing: CGFloat = 14
        static let sectionContentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 18.0, leading: 28.0, bottom: 18.0, trailing: 28.0
        )
        static let itemSpacing: CGFloat = 28.0 * 2 + groupInterItemSpacing
    }
    
    // MARK: - ui component
    
    private lazy var friendListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cell: FriendCollectionViewCell.self,
                                forCellWithReuseIdentifier: FriendCollectionViewCell.className)
        return collectionView
    }()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubview(self.friendListCollectionView)
        self.friendListCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }
    
    // MARK: - func
    
    func configureNavigationBar(_ viewController: UIViewController) {
        viewController.title = TextLiteral.Detail.togetherFriendTitle.localized()
    }
    
    func collectionView() -> UICollectionView {
        return self.friendListCollectionView
    }
}

// MARK: - UICollectionViewLayout
extension FriendListView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { index, environment -> NSCollectionLayoutSection? in
            let itemWidth = ((self.window?.windowScene?.screen.bounds.width ?? 0) - ConstantSize.itemSpacing) / 2
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .absolute(itemWidth)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(itemWidth)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let groupSpacing = NSCollectionLayoutSpacing.fixed(ConstantSize.groupInterItemSpacing)
            group.interItemSpacing = groupSpacing
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = ConstantSize.sectionContentInset
            section.interGroupSpacing = ConstantSize.groupInterItemSpacing
            
            return section
        }
        
        return layout
    }
}
