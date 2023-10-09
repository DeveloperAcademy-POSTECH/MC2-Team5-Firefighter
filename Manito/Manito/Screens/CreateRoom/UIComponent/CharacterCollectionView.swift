//
//  ChooseCharacterView.swift
//  Manito
//
//  Created by 이성호 on 2023/05/10.
//

import Combine
import UIKit

import SnapKit

final class CharacterCollectionView: UIView {
    
    private enum InternalSize {
        static let collectionHorizontalSpacing: CGFloat = 29.0
        static let cellInterSpacing: CGFloat = 39.0
        static let cellLineSpacing: CGFloat = 24.0
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - (collectionHorizontalSpacing * 2 + cellInterSpacing * 2)) / 3
        static let collectionInset = UIEdgeInsets.zero
    }
    
    // MARK: - ui component

    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = InternalSize.collectionInset
        flowLayout.minimumLineSpacing = InternalSize.cellLineSpacing
        flowLayout.minimumInteritemSpacing = InternalSize.cellInterSpacing
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.itemSize = CGSize(width: InternalSize.cellWidth, height: InternalSize.cellWidth)
        return flowLayout
    }()
    private lazy var manittoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(cell: CharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterCollectionViewCell.className)
        return collectionView
    }()
    
    // MARK: - property
    // FIXME: CreateRoom ViewModel 변경시 삭제예정
    let characterIndexTapPublisher = CurrentValueSubject<Int, Never>(0)
    private(set) var characterIndex: Int = 0
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.manittoCollectionView)
        self.manittoCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension CharacterCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DefaultCharacterType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.className, for: indexPath) as? CharacterCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureBackgroundColor(color: DefaultCharacterType.allCases[indexPath.item].backgroundColor)
        cell.configureImage(image: DefaultCharacterType.allCases[indexPath.item].image)
        
        if indexPath.item == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false , scrollPosition: .init())
        }
        
        return cell
    }
}

extension CharacterCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.characterIndex = indexPath.item
    }
}
