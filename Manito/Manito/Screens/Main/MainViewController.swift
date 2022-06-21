//
//  MainViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class MainViewController: BaseViewController {
    
    // 임시 데이터
    let roomData = ["명예소방관1", "명예소방관2", "명예소방관3", "명예소방관4", "명예소방관5"]
    private let nickname = "코비"
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 22
        static let collectionVerticalSpacing: CGFloat = 17
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2 - collectionVerticalSpacing) / 2
        static let collectionInset = UIEdgeInsets(top: 0,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    // MARK: - property
    
    private let appTitleView = UIImageView(image: ImageLiterals.imgLogo)
    
    private let settingButton = SettingButton()
    
    private let imgStar = UIImageView(image: ImageLiterals.imgStar)
    
    private let commonMissionImageView = UIImageView(image: ImageLiterals.imgCommonMisson)
    
    private let commonMissionView = CommonMissonView()
    
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
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
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
        collectionView.register(cell: CreateRoomCollectionViewCell.self,
                                forCellWithReuseIdentifier: CreateRoomCollectionViewCell.className)
        return collectionView
    }()
    
    private let imgNi = UIImageView(image: ImageLiterals.imgNi)
    
    private let imgMa = UIImageView(image: ImageLiterals.imgMa)
    
    private let imgTto = UIImageView(image: ImageLiterals.imgTto)

    // MARK: - life cycle
    
    override func render() {
        view.addSubview(imgNi)
        imgNi.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(54)
            $0.bottom.equalToSuperview().inset(44)
            $0.height.width.equalTo(75)
        }
        
        view.addSubview(imgMa)
        imgMa.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
            $0.height.width.equalTo(75)
        }
        
        view.addSubview(imgTto)
        imgTto.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(54)
            $0.bottom.equalToSuperview().inset(44)
            $0.height.width.equalTo(75)
        }
        
        view.addSubview(imgStar)
        imgStar.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.leading.equalToSuperview().inset(13)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        view.addSubview(commonMissionImageView)
        commonMissionImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(commonMissionImageView.snp.width).multipliedBy(0.61)
            $0.top.equalTo(imgStar.snp.bottom)
        }
        
        commonMissionImageView.addSubview(commonMissionView)
        commonMissionView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        view.addSubview(menuTitle)
        menuTitle.snp.makeConstraints {
            $0.top.equalTo(commonMissionImageView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(16)
        }
        
        view.addSubview(listCollectionView)
        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(menuTitle.snp.bottom).offset(17)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configUI() {
        super.configUI()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        let appTitleView = makeBarButtonItem(with: appTitleView)
        let settingButtonView = makeBarButtonItem(with: settingButton)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.leftBarButtonItem = appTitleView
        navigationItem.rightBarButtonItem = settingButtonView
    }
    
    func newRoom() {
        let alert = UIAlertController(title: "새로운 마니또 시작", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let createRoom = UIAlertAction(title: "방 생성하기", style: .default, handler: nil)
        let enterRoom = UIAlertAction(title: "방 참가하기", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(createRoom)
        alert.addAction(enterRoom)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < roomData.count {
            let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: ManitoRoomCollectionViewCell.className, for: indexPath)
            
            guard let ManitoRoomCollectionViewCell = dequeuedCell as? ManitoRoomCollectionViewCell else {
                assert(false, "Wrong ManitoRoomCollectionViewCell")
            }
            
            ManitoRoomCollectionViewCell.roomLabel.text = roomData[indexPath.item]
            
            // configure your ManitoRoomCollectionViewCell
            
            return ManitoRoomCollectionViewCell
        } else {
            let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateRoomCollectionViewCell.className, for: indexPath)
            
            guard let CreateRoomCollectionViewCell = dequeuedCell as? CreateRoomCollectionViewCell else {
                assert(false, "Wrong CreateRoomCollectionViewCell")
            }
            
            // configure your CreateRoomCollectionViewCell
            
            return CreateRoomCollectionViewCell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < roomData.count {
            print("방 클릭")
        } else {
            newRoom()
        }
    }
}
