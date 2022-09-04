//
//  ChooseRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/18.
//

import UIKit

import SnapKit

class ChooseCharacterViewController: BaseViewController {
    
    private enum Size {
        static let leadingTrailingPadding: CGFloat = 20
        static let collectionHorizontalSpacing: CGFloat = 29.0
        static let collectionVerticalSpacing: CGFloat = 37.0
        static let cellInterSpacing: CGFloat = 39.0
        static let cellLineSpacing: CGFloat = 20.0
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - (collectionHorizontalSpacing * 2 + cellInterSpacing * 2)) / 3
        static let collectionInset = UIEdgeInsets(top: collectionVerticalSpacing,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    private let charactersData: [[String: Any]] = [
        [
            "colorIdx": 0,
            "image": ImageLiterals.imgCharacterPink,
            "color": UIColor.characterYellow
        ],
        [
            "colorIdx": 1,
            "image": ImageLiterals.imgCharacterBrown,
            "color": UIColor.characterRed
        ],
        [
            "colorIdx": 2,
            "image": ImageLiterals.imgCharacterBlue,
            "color": UIColor.characterOrange
        ],
        [
            "colorIdx": 3,
            "image": ImageLiterals.imgCharacterRed,
            "color": UIColor.characterBlue
        ],
        [
            "colorIdx": 4,
            "image": ImageLiterals.imgCharacterOrange,
            "color": UIColor.characterLightGreen
        ],
        [
            "colorIdx": 5,
            "image": ImageLiterals.imgCharacterYellow,
            "color": UIColor.characterPurple
        ],
        [
            "colorIdx": 6,
            "image": ImageLiterals.imgCharacterLightGreen,
            "color": UIColor.characterGreen
        ],
        [
            "colorIdx": 7,
            "image": ImageLiterals.imgCharacterHeavyPink,
            "color": UIColor.backgroundGrey
        ],
        [
            "colorIdx": 8,
            "image": ImageLiterals.imgCharacterPurple,
            "color": UIColor.characterPink
        ],
    ]
    
    // MARK: - Property
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "캐릭터 선택"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "당신만의 캐릭터를 정해주세요."
        label.font = .font(.regular, ofSize: 18)
        label.textColor = .grey002
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = Size.collectionInset
        flowLayout.minimumLineSpacing = Size.cellLineSpacing
        flowLayout.minimumInteritemSpacing = Size.cellInterSpacing
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellWidth)
        return flowLayout
    }()
    
    private lazy var manittoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(cell: CharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterCollectionViewCell.className)
        return collectionView
    }()
    
    private lazy var enterButton: MainButton = {
        let button = MainButton()
        button.title = "선택"
        button.addTarget(self, action: #selector(didTapEnterButton), for: .touchUpInside)
        return button
    }()
    
    override func render() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(manittoCollectionView)
        manittoCollectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(enterButton)
        enterButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalToSuperview().inset(57)
            $0.height.equalTo(60)
        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Selectors
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapEnterButton() {
        print("didTapEnterButton")
    }
}

// MARK: - UICollectionViewDataSource
extension ChooseCharacterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CharacterCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        if indexPath.item == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false , scrollPosition: .init())
        }
        
        cell.backgroundColor = charactersData[indexPath.item]["color"] as? UIColor
        cell.characterImageView.image = charactersData[indexPath.item]["image"] as? UIImage
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ChooseCharacterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택한 마니또 이미지 정보 출력
        print(charactersData[indexPath.item])
    }
}
