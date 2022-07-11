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
    let developerData: [[String: String]] = [
        [
            "imageName": "imgNi",
            "name": "김도영 Coby",
            "info": "디너를 좋아하는 코비"
        ],
        [
            "imageName": "imgNi",
            "name": "방석진 Leo",
            "info": "서버를 위해 온 천사 리오"
        ],
        [
            "imageName": "imgNi",
            "name": "신윤아 Duna",
            "info": "그저 신! 갓듀나^__^"
        ],
        [
            "imageName": "imgNi",
            "name": "이성호 Hoya",
            "info": "아낌없이 주고 (마시는) 호야"
        ],
        [
            "imageName": "imgNi",
            "name": "이정환 Dinner",
            "info": "하면 다 잘 하는 디너"
        ],
        [
            "imageName": "imgNi",
            "name": "최민관 Chemi",
            "info": "우직하고 호기심 가득한 케미"
        ],
        [
            "imageName": "imgNi",
            "name": "최성희 Livvy",
            "info": "여려 보이지만 강한 리비"
        ],
        [
            "imageName": "imgNi",
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
    
    private let developerRoomView = UIImageView(image: ImageLiterals.imgCommonMisson)
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = Size.collectionInset
        flowLayout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        flowLayout.minimumLineSpacing = 40
        return flowLayout
    }()
    
    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
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

    override func configUI() {
        super.configUI()
    }
}


// MARK: - UICollectionViewDataSource
extension DeveloperInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return developerData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: DeveloperInfoViewCell.className, for: indexPath)

        guard let DeveloperInfoViewCell = dequeuedCell as? DeveloperInfoViewCell else {
            assert(false, "Wrong DeveloperInfoViewCell")
        }

        DeveloperInfoViewCell.nameLabel.text = developerData[indexPath.item]["name"]
        DeveloperInfoViewCell.infoLabel.text = developerData[indexPath.item]["info"]

        // configure your DeveloperInfoViewCell

        return DeveloperInfoViewCell
    }
}


// MARK: - UICollectionViewDelegate
extension DeveloperInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
