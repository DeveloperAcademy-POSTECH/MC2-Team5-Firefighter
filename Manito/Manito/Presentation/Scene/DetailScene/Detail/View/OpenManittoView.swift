//
//  OpenManittoView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/27.
//

import UIKit

import SnapKit

protocol OpenManittoViewDelegate: AnyObject {
    func confirmButtonTapped()
}

final class OpenManittoView: UIView, BaseViewType {

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
        collectionView.register(cell: OpenManittoCollectionViewCell.self,
                                forCellWithReuseIdentifier: OpenManittoCollectionViewCell.className)
        return collectionView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 34)
        label.text = TextLiteral.DetailIng.openManittoTitle.localized()
        return label
    }()
    private let popupView: OpenManittoPopupView = OpenManittoPopupView()
    
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

        self.addSubview(self.popupView)
        self.popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }

    // MARK: - func

    func configureDelegation(_ delegate: UICollectionViewDataSource & OpenManittoViewDelegate) {
        self.manittoCollectionView.dataSource = delegate
        self.popupView.configureDelegation(delegate)
    }
    
    func updateCollectionView() {
        self.manittoCollectionView.reloadData()
    }
    
    func updatePopupView(text: String) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.popupView.fadeIn(duration: 0.2)
            self.popupView.setupTypingAnimation(text)
        }
    }
}
