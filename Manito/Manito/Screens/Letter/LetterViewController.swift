//
//  LetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

final class LetterViewController: BaseViewController {
    
    private enum LetterState: Int {
        case received = 0
        case sent = 1
        
        var lists: [Letter] {
            switch self {
            case .received:
                return receivedLetters
            case .sent:
                return sentLetters
            }
        }
    }
    
    private enum Size {
        static let headerHeight: CGFloat = 66.0
        static let emptyContentHeight: CGFloat = 48.0
        static let collectionHorizontalSpacing: CGFloat = 20.0
        static let collectionVerticalSpacing: CGFloat = 18.0
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2
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
        flowLayout.minimumLineSpacing = 33
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.estimatedItemSize = CGSize(width: Size.cellWidth, height: Size.emptyContentHeight)
        return flowLayout
    }()
    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cell: LetterCollectionViewCell.self,
                                forCellWithReuseIdentifier: LetterCollectionViewCell.className)
        collectionView.register(LetterHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: LetterHeaderView.className)
        return collectionView
    }()
    private let sendLetterView = SendLetterView()
    
    private var letterState: LetterState = .received {
        didSet {
            reloadCollectionView(with: self.letterState)
        }
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonAction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func render() {
        view.addSubview(listCollectionView)
        listCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(sendLetterView)
        sendLetterView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configUI() {
        super.configUI()
        sendLetterView.isHidden = (letterState == .received)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        title = "쪽지함"
    }
    
    // MARK: - func
    
    private func setupButtonAction() {
        let presentSendButtonAction = UIAction { _ in
            let storyboard = UIStoryboard(name: "Letter", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "CreateLetterNavigationController")
            self.present(viewController, animated: true, completion: nil)
        }
        sendLetterView.sendLetterButton.addAction(presentSendButtonAction,
                                                  for: .touchUpInside)
    }
    
    private func reloadCollectionView(with state: LetterState) {
        let isReceivedState = (state == .received)
        let bottomInset: CGFloat = (isReceivedState ? 0 : 73)
        let topPoint = listCollectionView.adjustedContentInset.top + 1
        
        sendLetterView.isHidden = isReceivedState
        listCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        listCollectionView.setContentOffset(CGPoint(x: 0, y: -topPoint), animated: false)
        listCollectionView.collectionViewLayout.invalidateLayout()
        listCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension LetterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letterState.lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LetterCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setLetterData(with: letterState.lists[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LetterHeaderView.className, for: indexPath) as? LetterHeaderView else { assert(false, "do not have reusable view") }
            
            headerView.segmentControlIndex = letterState.rawValue
            headerView.changeSegmentControlIndex = { [weak self] index in
                guard let letterStatus = LetterState.init(rawValue: index) else { return }
                self?.letterState = letterStatus
            }
            
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
