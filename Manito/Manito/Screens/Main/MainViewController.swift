//
//  MainViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit
import SnapKit

class MainViewController: BaseViewController {
    
    private let nickname = "코비"
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 24
        static let collectionVerticalSpacing: CGFloat = 24
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 3)/2
        static let collectionInset = UIEdgeInsets(top: 0,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    // MARK: - property
    
    private var appTitleView: AppTitleView = {
        let view = AppTitleView()
        return view
    }()
    
    private let settingButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        return button
    }()
    
    private var lightImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        return image
    }()
    
    private var commonMissionView: CommonMissonView = {
        let view = CommonMissonView()
        return view
    }()
    
    private lazy var menuTitle: UILabel = {
        let label = UILabel()
        label.text = "\(nickname)의 마니또"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = Size.collectionInset
        flowLayout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellWidth)
        flowLayout.minimumLineSpacing = 24
        flowLayout.sectionHeadersPinToVisibleBounds = true
        return flowLayout
    }()
    
    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cell: ManitoRoomCollectionViewCell.self,
                                forCellWithReuseIdentifier: ManitoRoomCollectionViewCell.className)
        return collectionView
    }()

    // MARK: - life cycle
    
    override func render() {
        
        view.addSubview(lightImage)
        lightImage.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(30)
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        
        view.addSubview(commonMissionView)
        commonMissionView.snp.makeConstraints {
//            $0.height.equalTo(UIScreen.main.bounds.size.width - 48).multipliedBy(0.4)
            $0.height.equalTo(200)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(lightImage.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(menuTitle)
        menuTitle.snp.makeConstraints {
            $0.top.equalTo(commonMissionView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(16)
        }
        
        view.addSubview(listCollectionView)
        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(menuTitle.snp.bottom).offset(18)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configUI() {
        super.configUI()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .automatic
        let appTitleView = makeBarButtonItem(with: appTitleView)
        let settingButtonView = makeBarButtonItem(with: settingButton)
        navigationItem.leftBarButtonItem = appTitleView
        navigationItem.rightBarButtonItem = settingButtonView
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ManitoRoomCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("체크")
    }
}
