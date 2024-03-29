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

final class MainViewController: UIViewController, BaseViewControllerType {
    
    private enum InternalSize {
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
    
    // MARK: - ui component
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.Image.background
        return imageView
    }()
    private let skeletonAnimation: SkeletonLayerAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let appTitleView: UIImageView = UIImageView(image: UIImage.Image.logo)
    private lazy var settingButton: SettingButton = {
        let button = SettingButton()
        let action = UIAction { [weak self] _ in
            let repository = SettingRepositoryImpl()
            let usecase = SettingUsecaseImpl(repository: repository)
            let viewModel = SettingViewModel(usecase: usecase)
            self?.navigationController?.pushViewController(SettingViewController(viewModel: viewModel), animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    private let imgStar: UIImageView = UIImageView(image: UIImage.Image.star)
    private let commonMissionView: CommonMissionView = CommonMissionView()
    private let menuTitle: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.Main.listTitle.localized()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = InternalSize.collectionInset
        flowLayout.itemSize = CGSize(width: InternalSize.cellWidth, height: InternalSize.cellWidth)
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        return flowLayout
    }()
    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
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
    private let maCharacterImageView: GIFImageView = GIFImageView()
    private let niCharacterImageView: GIFImageView = GIFImageView()
    private let ttoCharacterImageView: GIFImageView = GIFImageView()
    private let guideView: GuideView = GuideView(type: .main)
    
    // MARK: - property
    
    private let mainRepository: MainRepository = MainRepositoryImpl()
    private var rooms: [RoomListItemDTO]?
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.baseViewDidLoad()
        self.setupGifImage()
        self.setupRefreshControl()
        self.setupSkeletonView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegateInteractivePopGesture()
        self.requestCommonMission()
        self.requestManittoRoomList()
    }
    
    // MARK: - base func

    func setupLayout() {
        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
        
        self.view.addSubview(self.commonMissionView)
        self.commonMissionView.snp.makeConstraints {
            $0.top.equalTo(self.imgStar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.height.equalTo(InternalSize.commonMissionViewHeight)
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
        
        self.commonMissionView.addSubview(self.guideView)
        self.guideView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(30)
        }
        self.guideView.setupGuideViewLayout()
    }

    func configureUI() {
        self.view.backgroundColor = .backgroundGrey
    }

    // MARK: - override

    private func setupNavigationBar() {
        let appTitleView = self.makeBarButtonItem(with: self.appTitleView)
        let settingButtonView = self.makeBarButtonItem(with: self.settingButton)

        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.leftBarButtonItem = appTitleView
        self.navigationItem.rightBarButtonItem = settingButtonView
    }

    override func endEditingView() {
        self.guideView.didTapAroundToHideGuideView()
    }
    
    // MARK: - func
    
    private func setupGifImage() {
        DispatchQueue.main.async {
            self.maCharacterImageView.animate(withGIFNamed: GIFSet.ma, animationBlock: nil)
            self.niCharacterImageView.animate(withGIFNamed: GIFSet.ni, animationBlock: nil)
            self.ttoCharacterImageView.animate(withGIFNamed: GIFSet.tto, animationBlock: nil)
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
        self.listCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.grey003, .darkGrey002]),
                                                             animation: skeletonAnimation,
                                                             transition: .none)
    }
    
    private func stopSkeletonView() {
        self.listCollectionView.stopSkeletonAnimation()
        self.listCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
    }

    private func createNewRoom() {
        let alert = UIAlertController(title: TextLiteral.Main.menuTitle.localized(),
                                      message: nil,
                                      preferredStyle: .actionSheet)

        let createRoom = UIAlertAction(title: TextLiteral.Common.createRoom.localized(),
                                       style: .default,
                                       handler: { [weak self] _ in
            let repository = RoomParticipationRepositoryImpl()
            let usecase = CreateRoomUsecaseImpl(repository: repository)
            let textFieldUsecase = TextFieldUsecaseImpl()
            let viewController = CreateRoomViewController(viewModel: CreateRoomViewModel(usecase: usecase,
                                                                                         textFieldUsecase: textFieldUsecase))
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async {
                self?.present(navigationController,animated: true)
            }
        })
        let enterRoom = UIAlertAction(title: TextLiteral.Common.enterRoom.localized(),
                                      style: .default,
                                      handler: { [weak self] _ in
            let usecase = ParticipateRoomUsecaseImpl(repository: RoomParticipationRepositoryImpl())
            let textFieldUsecase = TextFieldUsecaseImpl()
            let viewModel = ParticipateRoomViewModel(usecase: usecase,
                                                     textFieldUsecase: textFieldUsecase)
            let viewController = ParticipateRoomViewController(viewModel: viewModel)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        })
        let cancel = UIAlertAction(title: TextLiteral.Common.cancel.localized(), style: .cancel)

        alert.addAction(createRoom)
        alert.addAction(enterRoom)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }

    // FIXME: - roomIndex가 현재 item으로 설정되어 있고, index가 roomIndex로 설정되어있음. KTBQ2B
    private func pushDetailView(status: RoomStatus, roomIndex: Int, index: Int? = nil) {
        switch status {
        case .PRE:
            guard let index = index else { return }
            let viewModel = DetailWaitViewModel(roomId: index.description, usecase: DetailWaitUseCaseImpl(repository: DetailRoomRepositoryImpl()))
            let viewController = DetailWaitViewController(viewModel: viewModel)
            
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            guard let roomId = rooms?[roomIndex].id?.description
            else { return }
            let viewController = DetailingViewController(roomId: roomId)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func pushDetailViewController(roomId: Int) {
        let viewController = DetailingViewController(roomId: roomId.description)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.pushViewController(viewController, animated: true)
            viewController.pushNavigationAfterRequestRoomInfo()
        }
    }
    
    func showRoomIdErrorAlert() {
        self.makeAlert(title: TextLiteral.Main.Error.title,
                       message: TextLiteral.Main.Error.message)
    }
    
    private func delegateInteractivePopGesture() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: - network
    
    private func requestCommonMission() {
        Task {
            do {
                let data = try await self.mainRepository.fetchCommonMission()
                if let commonMission = data.mission {
                    self.commonMissionView.missionLabel.text = commonMission
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
    
    private func requestManittoRoomList() {
        Task {
            do {
                let data = try await self.mainRepository.fetchManittoList()
                self.rooms = data.participatingRooms
                self.listCollectionView.reloadData()
                self.stopSkeletonView()
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

// MARK: - SkeletonCollectionViewDataSource
extension MainViewController: SkeletonCollectionViewDataSource {
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
            
            cell.roomStateView.stateLabel.text = roomStatus.badgeTitle
            cell.roomStateView.stateLabel.textColor = roomStatus.titleColor
            cell.roomStateView.backgroundColor = roomStatus.badgeColor
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            self.createNewRoom()
        } else {
            guard let state = self.rooms?[indexPath.item - 1].state,
                  let roomStatus = RoomStatus.init(rawValue: state),
                  let id = self.rooms?[indexPath.item - 1].id
            else { return }
            if roomStatus == .PRE {
                self.pushDetailView(status: roomStatus, roomIndex: indexPath.item - 1, index: id)
            } else {
                self.pushDetailView(status: roomStatus, roomIndex: indexPath.item - 1)
            }
        }
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
