//
//  DeveloperInfoViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/07/10.
//

import UIKit

import SnapKit

class DeveloperInfoViewController: BaseViewController {
    
    // 개발자 정보 데이터
    private let developerData: [[String: Any]] = [
        [
            "image": ImageLiterals.imgMaCoby,
            "name": "김도영 Coby",
            "info": "디너를 좋아하는 코비"
        ],
        [
            "image": ImageLiterals.imgMaLeo,
            "name": "방석진 Leo",
            "info": "서버를 위해 온 천사 리오"
        ],
        [
            "image": ImageLiterals.imgMaDuna,
            "name": "신윤아 Duna",
            "info": "그저 신! 갓듀나^__^"
        ],
        [
            "image": ImageLiterals.imgMaHoya,
            "name": "이성호 Hoya",
            "info": "아낌없이 주고 (마시는) 호야"
        ],
        [
            "image": ImageLiterals.imgMaDinner,
            "name": "이정환 Dinner",
            "info": "하면 다 잘 하는 디너"
        ],
        [
            "image": ImageLiterals.imgMaChemi,
            "name": "최민관 Chemi",
            "info": "우직하고 호기심 가득한 케미"
        ],
        [
            "image": ImageLiterals.imgMaLivvy,
            "name": "최성희 Livvy",
            "info": "여려 보이지만 강한 리비"
        ],
        [
            "image": ImageLiterals.imgMaDaon,
            "name": "홍지혜 Daon",
            "info": "서버를 위해 온 천사 다온"
        ]
    ]
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 20
        static let collectionVerticalSpacing: CGFloat = 40
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - 40)
        static let cellHeight: CGFloat = 100
        static let collectionInset = UIEdgeInsets(top: 0,
            left: collectionHorizontalSpacing,
            bottom: collectionVerticalSpacing,
            right: collectionHorizontalSpacing)
    }
    

    // MARK: - property
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "개발자 정보"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    
    private let developerRoomView = UIImageView(image: ImageLiterals.imgDevBackground)
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = Size.collectionInset
        flowLayout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        flowLayout.minimumLineSpacing = 15
        return flowLayout
    }()
    
    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cell: DeveloperInfoViewCell.self,
            forCellWithReuseIdentifier: DeveloperInfoViewCell.className)
        return collectionView
    }()

    // MARK: - life cycle

    override func render() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.addSubview(developerRoomView)
        developerRoomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(55)
            $0.height.equalTo(developerRoomView.snp.width).multipliedBy(0.62)
        }
        
        view.addSubview(listCollectionView)
        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(developerRoomView.snp.bottom).offset(47)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}


// MARK: - UICollectionViewDataSource
extension DeveloperInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return developerData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeveloperInfoViewCell.className, for: indexPath) as? DeveloperInfoViewCell else {
            assert(false, "Wrong Cell")
        }
        
        cell.developerImageView.image = developerData[indexPath.item]["image"] as? UIImage
        cell.nameLabel.text = developerData[indexPath.item]["name"] as? String
        cell.infoLabel.text = developerData[indexPath.item]["info"] as? String
        
        return cell
    }
}
