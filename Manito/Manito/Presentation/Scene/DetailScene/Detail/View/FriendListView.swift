//
//  FriendListView.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/19/23.
//

import UIKit

import SnapKit

final class FriendListView: UIView, BaseViewType {
    
    // MARK: - ui component
    
    private let friendListCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.backgroundColor = .clear
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
        
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }
}

// MARK: - UICollectionViewLayout
extension FriendListView {
    private func createLayout() -> UICollectionViewLayout {
        
    }
}
