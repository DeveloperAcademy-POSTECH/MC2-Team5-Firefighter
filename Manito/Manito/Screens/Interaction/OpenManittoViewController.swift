//
//  OpenManittoViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import UIKit

import SnapKit

final class OpenManittoViewController: BaseViewController {
    
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
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(cell: ManittoCollectionViewCell.self,
                                forCellWithReuseIdentifier: ManittoCollectionViewCell.className)
        return collectionView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 34)
        label.text = TextLiteral.openManittoViewControllerTitle
        return label
    }()

    // MARK: - property

    private let openManittoService: DetailIngAPI = DetailIngAPI(apiService: APIService())

    private var manittoRandomIndex = -1 {
        didSet {
            self.manittoCollectionView.reloadData()
        }
    }
    private var friendsList: FriendList = FriendList(count: 0, members: [])
    private var manitto: String = ""
    private var manittoIndex = 0
    private var roomId: String
    
    // MARK: - init
    
    init(roomId: String) {
        self.roomId = roomId
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestWithFriends(roomId: roomId)
    }

    // MARK: - override
    
    override func setupLayout() {
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(57)
            $0.leading.equalToSuperview().inset(16)
        }
        
        self.view.addSubview(self.manittoCollectionView)
        self.manittoCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - func
    
    private func animateCollectionView() {
        guard let count = self.friendsList.count else { return }
        let timeInterval: Double = 0.3
        let durationTime: Double = timeInterval * Double(count)
        let delay: Double = 1.0
        
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
                  let count = self.friendsList.count,
                  countNumber != self.friendsList.count else { return }
            let characterCount = count - 1
            
            self.manittoRandomIndex = Int.random(in: 0...characterCount, excluding: self.manittoRandomIndex)
            countNumber += 1
        }
    }
    
    private func setManittoAnimation(with deadline: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            self.manittoRandomIndex = self.manittoIndex
        })

        DispatchQueue.main.asyncAfter(deadline: deadline + 1.0, execute: {
            self.presentPopupViewController()
        })
    }
    
    private func presentPopupViewController() {
        let storyboard = UIStoryboard(name: "Interaction", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: OpenManittoPopupViewController.className) as? OpenManittoPopupViewController else { return }
        viewController.manittoNickname = manitto
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - network
    
    private func requestWithFriends(roomId: String) {
        Task {
            do {
                let data = try await self.openManittoService.requestWithFriends(roomId: roomId)
                if let list = data {
                    self.friendsList = list
                    DispatchQueue.main.async {
                        self.requestRoomInfo(roomId: roomId)
                        self.animateCollectionView()
                        self.manittoCollectionView.reloadData()
                    }
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
    }
    
    private func requestRoomInfo(roomId: String) {
        Task {
            do {
                let data = try await self.openManittoService.requestStartingRoomInfo(roomId: roomId)
                if let info = data {
                    guard let nickname = info.manitto?.nickname else { return }
                    self.manitto = nickname
                    
                    self.manittoIndex = self.friendsList.members?.firstIndex(where: { $0.nickname == self.manitto }) ?? 0
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension OpenManittoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.friendsList.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ManittoCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

        if let colorIdx = self.friendsList.members?[indexPath.item].colorIdx {
            cell.setManittoCell(with: colorIdx)
            cell.setHighlightCell(with: indexPath.item, matchIndex: self.manittoRandomIndex, imageIndex: colorIdx)
        }

        return cell
    }
}
