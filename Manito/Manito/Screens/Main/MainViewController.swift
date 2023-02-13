//
//  MainViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import Gifu
import SkeletonView
import SnapKit

final class MainViewController: BaseViewController {
    
    private let mainService: MainProtocol = MainAPI(apiService: APIService())
    private var rooms: [ParticipatingRoom]?
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 20
        static let collectionVerticalSpacing: CGFloat = 20
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 3) / 2
        static let collectionInset = UIEdgeInsets(top: 0,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
        static let commonMissionViewWidth: CGFloat = UIScreen.main.bounds.size.width - 40
        static let commonMissionViewHeight: CGFloat = commonMissionViewWidth * 0.6
    }
    
    private enum RoomStatus: String {
        case waiting = "PRE"
        case starting = "PROCESSING"
        case end = "POST"
        
        var roomStatus: String {
            switch self {
            case .waiting:
                return TextLiteral.waiting
            case .starting:
                return TextLiteral.doing
            case .end:
                return TextLiteral.done
            }
        }
    }
    
    private let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
    
    private let refreshControl = UIRefreshControl()

    // MARK: - property

    private let appTitleView = UIImageView(image: ImageLiterals.imgLogo)
    private lazy var settingButton: SettingButton = {
        let button = SettingButton()
        let action = UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(SettingViewController(), animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    private let imgStar = UIImageView(image: ImageLiterals.imgStar)
    private let commonMissionView = CommonMissionView()
    private let menuTitle: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.mainViewControllerMenuTitle
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
        collectionView.isSkeletonable = true
        return collectionView
    }()
    private let maCharacterImageView = GIFImageView()
    private let niCharacterImageView = GIFImageView()
    private let ttoCharacterImageView = GIFImageView()
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGifImage()
        self.setupGuideArea()
        self.renderGuideArea()
        self.setupRefreshControl()
        self.setupSkeletonView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestCommonMission()
        self.requestManittoRoomList()
    }

    override func setupLayout() {
        self.view.addSubview(self.maCharacterImageView)
        self.maCharacterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(70)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.width.equalTo(75)
        }

        self.view.addSubview(self.niCharacterImageView)
        self.niCharacterImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
            $0.height.width.equalTo(75)
        }

        self.view.addSubview(self.ttoCharacterImageView)
        self.ttoCharacterImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(70)
            $0.bottom.equalToSuperview().inset(30)
            $0.height.width.equalTo(75)
        }

        self.view.addSubview(self.imgStar)
        self.imgStar.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.leading.equalToSuperview().inset(13)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
        }
        // FIXME: 좌우패딩 20값을 주는데 Size라는 변수명이 겹침
        self.view.addSubview(self.commonMissionView)
        self.commonMissionView.snp.makeConstraints {
            $0.top.equalTo(self.imgStar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Size.commonMissionViewHeight)
        }

        self.view.addSubview(self.menuTitle)
        self.menuTitle.snp.makeConstraints {
            $0.top.equalTo(self.commonMissionView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(16)
        }

        self.view.addSubview(self.listCollectionView)
        self.listCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.menuTitle.snp.bottom).offset(17)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.view.addSubview(self.guideButton)
        self.guideButton.snp.makeConstraints {
            $0.top.equalTo(self.commonMissionView.snp.top).offset(30)
            $0.trailing.equalTo(self.commonMissionView.snp.trailing).inset(30)
            $0.width.height.equalTo(44)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        let appTitleView = makeBarButtonItem(with: self.appTitleView)
        let settingButtonView = makeBarButtonItem(with: self.settingButton)

        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.leftBarButtonItem = appTitleView
        self.navigationItem.rightBarButtonItem = settingButtonView
    }
    
    override func setupGuideArea() {
        super.setupGuideArea()
        self.guideButton.setImage(ImageLiterals.icMissionInfo, for: .normal)
        self.setupGuideText(title: TextLiteral.mainViewControllerGuideTitle, text: TextLiteral.mainViewControllerGuideDescription)
    }
    
    private func setupGifImage() {
        DispatchQueue.main.async {
            self.maCharacterImageView.animate(withGIFNamed: ImageLiterals.gifMa, animationBlock: nil)
            self.niCharacterImageView.animate(withGIFNamed: ImageLiterals.gifNi, animationBlock: nil)
            self.ttoCharacterImageView.animate(withGIFNamed: ImageLiterals.gifTto, animationBlock: nil)
        }
    }
    
    private func setupRefreshControl() {
        let action = UIAction { [weak self] _ in
            self?.requestManittoRoomList()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.refreshControl.endRefreshing()
            }
        }
        self.refreshControl.addAction(action, for: .valueChanged)
        self.refreshControl.tintColor = .grey001
        self.listCollectionView.refreshControl = self.refreshControl
    }
    
    private func setupSkeletonView() {
        self.listCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.grey003, .darkGrey002]), animation: skeletonAnimation, transition: .none)
    }
    
    private func stopSkeletonView() {
        self.listCollectionView.stopSkeletonAnimation()
        self.listCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
    }
    
    // MARK: - API
    
    private func requestCommonMission() {
        Task {
            do {
                let data = try await self.mainService.fetchCommonMission()
                if let commonMission = data?.mission {
                    self.commonMissionView.mission.text = commonMission
                }
            } catch NetworkError.serverError {
                print("serverError")
            } catch NetworkError.clientError(let message) {
                print("clientError:\(String(describing: message))")
            }
        }
    }
    
    private func requestManittoRoomList() {
        Task {
            do {
                let data = try await self.mainService.fetchManittoList()
                
                if let manittoList = data {
                    self.rooms = manittoList.participatingRooms
                    self.listCollectionView.reloadData()
                    
                    self.stopSkeletonView()
                }
            } catch NetworkError.serverError {
                print("serverError")
            } catch NetworkError.clientError(let message) {
                print("clientError:\(String(describing: message))")
            }
        }
    }
    
    // MARK: - func

    private func newRoom() {
        let alert = UIAlertController(title: "새로운 마니또 시작", message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        let createRoom = UIAlertAction(title: TextLiteral.createRoom, style: .default, handler: { [weak self] _ in
            let createVC = CreateRoomViewController()
            let navigationController = UINavigationController(rootViewController: createVC)
            navigationController.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async {
                self?.present(navigationController,animated: true)
            }
        })
        let enterRoom = UIAlertAction(title: TextLiteral.enterRoom, style: .default, handler: { [weak self] _ in
            let viewController = ParticipateRoomViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            
            navigationController.modalPresentationStyle = .overFullScreen
            
            self?.present(navigationController, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: TextLiteral.cancel, style: .cancel, handler: nil)

        alert.addAction(createRoom)
        alert.addAction(enterRoom)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    private func presentParticipateRoomViewController() {
        let storyboard = UIStoryboard(name: "ParticipateRoom", bundle: nil)
        let ParticipateRoomVC = storyboard.instantiateViewController(identifier: "ParticipateRoomViewController")

        ParticipateRoomVC.modalPresentationStyle = .fullScreen
        ParticipateRoomVC.modalTransitionStyle = .crossDissolve

        self.present(ParticipateRoomVC, animated: true, completion: nil)
    }

    private func pushDetailView(status: RoomStatus, roomIndex: Int, index: Int? = nil) {
        switch status {
        case .waiting:
            guard let index = index else { return }
            let viewController = DetailWaitViewController(index: index)
            viewController.roomInformation = self.rooms?[roomIndex]
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            guard let roomId = rooms?[roomIndex].id?.description
            else { return }
            let viewController = DetailingCodebaseViewController(roomId: roomId)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func pushDetailViewController(roomId: Int) {
        let viewController = DetailingCodebaseViewController(roomId: roomId.description)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.pushViewController(viewController, animated: true)
            viewController.pushLetterViewControllerReceivedType()
        }
    }
    
    func showRoomIdErrorAlert() {
        makeRequestAlert(title: "해당 마니또 방의 정보를 불러오지 못했습니다.", message: "해당 마니또 방으로 이동할 수 없습니다.", okAction: nil)
    }
    
    @objc
    override func endEditingView() {
        if !self.guideButton.isTouchInside {
            self.guideBoxImageView.isHidden = true
        }
    }
}

// MARK: - SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource
extension MainViewController: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ManitoRoomCollectionViewCell.className
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.rooms?.count {
            return count + 1
        }
        
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateRoomCollectionViewCell.className, for: indexPath) as? CreateRoomCollectionViewCell else {
                assert(false, "Wrong Cell")
                return UICollectionViewCell()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManitoRoomCollectionViewCell.className, for: indexPath) as? ManitoRoomCollectionViewCell else {
                assert(false, "Wrong Cell")
                return UICollectionViewCell()
            }
            
            guard let roomData = self.rooms?[indexPath.item - 1] else { return cell }
            
            guard let participatingCount = roomData.participatingCount,
                  let capacity = roomData.capacity,
                  let title = roomData.title,
                  let startDate = roomData.startDate?.suffix(8),
                  let endDate = roomData.endDate?.suffix(8),
                  let state = roomData.state else { return cell }
            guard let roomStatus = RoomStatus.init(rawValue: state) else { return cell }
            
            cell.memberLabel.text = "\(participatingCount)/\(capacity)"
            cell.roomLabel.text = "\(title)"
            cell.dateLabel.text = "\(startDate) ~ \(endDate)"
            
            switch roomStatus {
            case .waiting:
                cell.roomStateView.state.text = "대기중"
                cell.roomStateView.state.textColor = .darkGrey001
                cell.roomStateView.backgroundColor = .badgeBeige
            case .starting:
                cell.roomStateView.state.text = "진행중"
                cell.roomStateView.state.textColor = .white
                cell.roomStateView.backgroundColor = .mainRed
            case .end:
                cell.roomStateView.state.text = "완료"
                cell.roomStateView.state.textColor = .white
                cell.roomStateView.backgroundColor = .grey002
            }
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            self.newRoom()
        } else {
            guard let state = self.rooms?[indexPath.item - 1].state,
                  let roomStatus = RoomStatus.init(rawValue: state),
                  let id = self.rooms?[indexPath.item - 1].id
            else { return }
            if roomStatus == .waiting {
                pushDetailView(status: roomStatus, roomIndex: indexPath.item - 1, index: id)
            } else {
                pushDetailView(status: roomStatus, roomIndex: indexPath.item - 1)
            }
        }
    }
}
