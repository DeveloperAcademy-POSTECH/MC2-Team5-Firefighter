//
//  MainViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import Gifu
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

    // MARK: - property

    private let appTitleView = UIImageView(image: ImageLiterals.imgLogo)
    private lazy var settingButton: SettingButton = {
        let button = SettingButton()
        button.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        return button
    }()
    private let imgStar = UIImageView(image: ImageLiterals.imgStar)
    private let commonMissionImageView = UIImageView(image: ImageLiterals.imgCommonMisson)
    private let commonMissionView = CommonMissonView()
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
        setupGifImage()
        setupGuideArea()
        renderGuideArea()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestCommonMission()
        requestManittoList()
    }

    override func render() {
        view.addSubview(maCharacterImageView)
        maCharacterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(70)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.width.equalTo(75)
        }

        view.addSubview(niCharacterImageView)
        niCharacterImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
            $0.height.width.equalTo(75)
        }

        view.addSubview(ttoCharacterImageView)
        ttoCharacterImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(70)
            $0.bottom.equalToSuperview().inset(30)
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
        
        view.addSubview(guideButton)
        guideButton.snp.makeConstraints {
            $0.top.equalTo(commonMissionImageView.snp.top).offset(27)
            $0.trailing.equalTo(commonMissionView.snp.trailing)
            $0.width.height.equalTo(44)
        }
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
    
    override func setupGuideArea() {
        super.setupGuideArea()
        guideButton.setImage(ImageLiterals.icMissionInfo, for: .normal)
        setupGuideText(title: TextLiteral.mainViewControllerGuideTitle, text: TextLiteral.mainViewControllerGuideDescription)
    }
    
    private func setupGifImage() {
        DispatchQueue.main.async {
            self.maCharacterImageView.animate(withGIFNamed: ImageLiterals.gifMa, animationBlock: nil)
            self.niCharacterImageView.animate(withGIFNamed: ImageLiterals.gifNi, animationBlock: nil)
            self.ttoCharacterImageView.animate(withGIFNamed: ImageLiterals.gifTto, animationBlock: nil)
        }
    }
    
    // MARK: - API
    
    private func requestCommonMission() {
        Task {
            do {
                let data = try await mainService.fetchCommonMission()
                if let commonMission = data?.mission {
                    commonMissionView.mission.text = commonMission
                }
            } catch NetworkError.serverError {
                print("serverError")
            } catch NetworkError.clientError(let message) {
                print("clientError:\(String(describing: message))")
            }
        }
    }
    
    private func requestManittoList() {
        Task {
            do {
                let data = try await mainService.fetchManittoList()
                
                if let manittoList = data {
                    rooms = manittoList.participatingRooms
                    listCollectionView.reloadData()
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
        present(alert, animated: true, completion: nil)
    }

    private func presentParticipateRoomViewController() {
        let storyboard = UIStoryboard(name: "ParticipateRoom", bundle: nil)
        let ParticipateRoomVC = storyboard.instantiateViewController(identifier: "ParticipateRoomViewController")

        ParticipateRoomVC.modalPresentationStyle = .fullScreen
        ParticipateRoomVC.modalTransitionStyle = .crossDissolve

        present(ParticipateRoomVC, animated: true, completion: nil)
    }

    private func pushDetailView(status: RoomStatus, roomIndex: Int, index: Int? = nil) {
        switch status {
        case .waiting:
            guard let index = index else { return }
            let viewController = DetailWaitViewController(index: index)
            viewController.roomInformation = rooms?[roomIndex]
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            let storyboard = UIStoryboard(name: "DetailIng", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: DetailIngViewController.className) as? DetailIngViewController else { return }
            viewController.roomInformation = rooms?[roomIndex]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - selector
    
    @objc
    private func didTapSettingButton() {
        navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    @objc
    override func endEditingView() {
        if !guideButton.isTouchInside {
            guideBoxImageView.isHidden = true
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = rooms?.count {
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
            
            guard let roomData = rooms?[indexPath.item - 1] else { return cell }
            
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
                cell.roomState.state.text = "대기중"
                cell.roomState.state.textColor = .darkGrey001
                cell.roomState.backgroundColor = .badgeBeige
            case .starting:
                cell.roomState.state.text = "진행중"
                cell.roomState.state.textColor = .white
                cell.roomState.backgroundColor = .mainRed
            case .end:
                cell.roomState.state.text = "완료"
                cell.roomState.state.textColor = .white
                cell.roomState.backgroundColor = .grey002
            }
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            newRoom()
        } else {
            guard let state = rooms?[indexPath.item - 1].state,
                  let roomStatus = RoomStatus.init(rawValue: state),
                  let id = rooms?[indexPath.item - 1].id
            else { return }
            if roomStatus == .waiting {
                pushDetailView(status: roomStatus, roomIndex: indexPath.item - 1, index: id)
            } else {
                pushDetailView(status: roomStatus, roomIndex: indexPath.item - 1)
            }
        }
    }
}
