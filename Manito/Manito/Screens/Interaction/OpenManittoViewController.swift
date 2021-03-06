//
//  OpenManittoViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import UIKit

import SnapKit

final class OpenManittoViewController: BaseViewController {
    
    private enum Size {
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
    
    // MARK: - property
    
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(cell: ManittoCollectionViewCell.self,
                                forCellWithReuseIdentifier: ManittoCollectionViewCell.className)
        return collectionView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "????????? ?????????????"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private var scrollNumberIndex = -1 {
        didSet {
            self.manittoCollectionView.reloadData()
        }
    }
    
    // FIXME: - ?????? ?????????
    private let manittoIndex = 4
    private let characters: [String] = ["", "", "", "", "", "", "", "", "", "", ""]
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateCollectionView()
    }
    
    override func render() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(57)
            $0.leading.equalToSuperview().inset(16)
        }
        
        view.addSubview(manittoCollectionView)
        manittoCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - func
    
    private func animateCollectionView() {
        let delay: CGFloat = 1.0
        let timeInterval = 0.2
        let durationTime = timeInterval * Double(characters.count)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.animate(withDuration: durationTime, animations: {
                self.setRandomAnimationTimer(withTimeInterval: timeInterval)
            }, completion: { _ in
                self.setManittoAnimation(with: .now() + delay + durationTime)
            })
        })
    }
    
    private func setRandomAnimationTimer(withTimeInterval timeInterval: TimeInterval) {
        var countNumber = 0
        
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {
            [weak self] _ in
            guard let self = self,
                countNumber != self.characters.count
            else { return }
            let characterCount = self.characters.count - 1
            
            self.scrollNumberIndex = Int.random(in: 0...characterCount, excluding: self.scrollNumberIndex)
            countNumber += 1
        }
    }
    
    private func setManittoAnimation(with deadline: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            self.scrollNumberIndex = self.manittoIndex
        })
        DispatchQueue.main.asyncAfter(deadline: deadline + 1.0, execute: {
            self.presentPopupViewController()
        })
    }
    
    private func presentPopupViewController() {
        let storyboard = UIStoryboard(name: "Interaction", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: OpenManittoPopupViewController.className) as? OpenManittoPopupViewController else { return }
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension OpenManittoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ManittoCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setManittoCell(with: indexPath.item)
        cell.setHighlightCell(with: indexPath.item, matchIndex: scrollNumberIndex)
        return cell
    }
}
