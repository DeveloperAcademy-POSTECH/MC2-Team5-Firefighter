//
//  LetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

final class LetterViewController: BaseViewController {
    
    private enum Size {
        static let headerHeight: CGFloat = 70.0
    }
    
    // MARK: - property
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()
    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LetterCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: LetterCollectionReusableView.className)
        return collectionView
    }()
    
    // MARK: - life cycle
    
    override func render() {
        view.addSubview(listCollectionView)
        listCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configUI() {
        super.configUI()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        title = "쪽지함"
    }
}

// MARK: - UICollectionViewDataSource
extension LetterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LetterCollectionReusableView.className, for: indexPath) as? LetterCollectionReusableView else { assert(false, "do not have reusable view") }
            return headerView
        default:
            assert(false, "do not use footer")
        }
    }
}

// MARK: - UICollectionViewDelegate
extension LetterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: Size.headerHeight)
    }
}
