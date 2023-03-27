//
//  DetailngCodebaseViewController.swift
//  Manito
//
//  Created by creohwan on 2022/11/03.
//

import UIKit

import SnapKit

final class DetailingViewController: BaseViewController {
    
    private let detailIngService: DetailIngAPI = DetailIngAPI(apiService: APIService())
    private let detailDoneService: DetailDoneAPI = DetailDoneAPI(apiService: APIService())
    
    private enum RoomType: String {
        case PROCESSING
        case POST
    }
    
    private let roomId: String
    private var roomType: RoomType = .PROCESSING
    private var isTappedManittee: Bool = false
    private var missionId: String = ""
    var letterViewController: UIViewController {
        guard let mission = missionContentsLabel.text else { return UIViewController() }
        let viewController = LetterViewController(roomState: roomType.rawValue,
                                                  roomId: roomId,
                                                  mission: mission,
                                                  missionId: self.missionId,
                                                  letterState: .received)
        return viewController
    }

    // MARK: - property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey002
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11
        label.textColor = .white
        label.font = .font(.regular, ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    private let missionBackgroundView: UIView = {
        var view = UIView()
        view.backgroundColor = .darkGrey004
        return view
    }()
    private let missionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.individualMissionViewTitleLabel
        label.textColor = .grey002
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    private let missionContentsLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        let attributedText = NSAttributedString(string: "", attributes: [.paragraphStyle: paragraphStyle])
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    private let informationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.detailIngViewControllerDetailInformatioin
        label.textColor = .white
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private lazy var manitteeBackView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedManittee))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .darkGrey002
        view.makeBorderLayer(color: .white)
        return view
    }()
    private let manitteeImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .subOrange
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey005.cgColor
        view.layer.cornerRadius = 49.5
        return view
    }()
    private let manitteeIconView = UIImageView(image: ImageLiterals.icManiTti)
    private let manitteeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(UserDefaultStorage.nickname ?? "당신")의 마니띠"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    private lazy var listBackView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushFriendListViewController(_:)))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .darkGrey002
        view.makeBorderLayer(color: .white)
        return view
    }()
    private let listImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .subPink
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey005.cgColor
        view.layer.cornerRadius = 49.5
        return view
    }()
    private let listIconView = UIImageView(image: ImageLiterals.icList)
    private let listLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.togetherFriend
        label.textColor = .white
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    private lazy var letterBoxButton: UIButton = {
        let button = UIButton(type: .system)
        let action = UIAction { [weak self] _ in
            guard let roomType = self?.roomType,
                  let roomId = self?.roomId,
                  let mission = self?.missionContentsLabel.text
            else { return }
            let letterViewController = LetterViewController(roomState: roomType.rawValue,
                                                            roomId: roomId,
                                                            mission: mission,
                                                            missionId: self?.missionId ?? "",
                                                            letterState: .sent)
            self?.navigationController?.pushViewController(letterViewController, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        button.setTitle(TextLiteral.letterViewControllerTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 15)
        button.backgroundColor = .darkGrey002
        button.makeBorderLayer(color: .white)
        return button
    }()
    private lazy var manittoMemoryButton: UIButton = {
        let button = UIButton(type: .system)
        let action = UIAction { [weak self] _ in
            guard let roomId = self?.roomId else { return }
            let viewController = MemoryViewController(roomId: roomId)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        button.setTitle(TextLiteral.memoryViewControllerTitleLabel, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 15)
        button.backgroundColor = .darkGrey002
        button.makeBorderLayer(color: .white)
        return button
    }()
    private let manitteeAnimationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.alpha = 0
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    private let manitiRealIconView: UIImageView = {
        let imageView = UIImageView(image: ImageLiterals.imgMa)
        imageView.alpha = 0
        return imageView
    }()
    private let manittoOpenButtonShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainRed
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 30
        view.makeShadow(color: .shadowRed, opacity: 1.0, offset: CGSize(width: 0, height: 6), radius: 1)
        view.isHidden = true
        return view
    }()
    // FIXME: - 마니또 공개 API 확실히 하기
    private lazy var manittoOpenButton: MainButton = {
        let button = MainButton()
        let action = UIAction { [weak self] _ in
            guard let roomId = self?.roomId else { return }
            let viewController = OpenManittoViewController(roomId: roomId)
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            self?.present(viewController, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        button.title = TextLiteral.detailIngViewControllerManitoOpenButton
        return button
    }()
    private let badgeLabel: LetterCountBadgeView = {
        let label = LetterCountBadgeView()
        label.layer.cornerRadius = 15
        label.isHidden = true
        return label
    }()
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.icMore, for: .normal)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    private let guideView: GuideView = GuideView(type: .detailing)
    
    // MARK: - init
    
    init(roomId: String) {
        self.roomId = roomId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLargeTitleToOriginal()
        requestRoomInfo()
    }
    
    override func setupLayout() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(19)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(periodLabel)
        periodLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(6)
            $0.width.equalTo(67)
            $0.height.equalTo(23)
        }

        view.addSubview(missionBackgroundView)
        missionBackgroundView.snp.makeConstraints {
            $0.top.equalTo(periodLabel.snp.bottom).offset(31)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.height.equalTo(100)
        }
        
        missionBackgroundView.addSubview(missionTitleLabel)
        missionTitleLabel.snp.makeConstraints{
            $0.top.equalTo(missionBackgroundView.snp.top).inset(12)
            $0.centerX.equalTo(missionBackgroundView.snp.centerX)
        }
        
        missionBackgroundView.addSubview(missionContentsLabel)
        missionContentsLabel.snp.makeConstraints{
            $0.centerY.equalTo(missionTitleLabel.snp.bottom).offset(30)
            $0.centerX.equalTo(missionBackgroundView.snp.centerX)
            $0.leading.trailing.equalTo(missionBackgroundView).inset(12)
        }

        view.addSubview(informationTitleLabel)
        informationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(missionBackgroundView.snp.bottom).offset(44)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(manitteeBackView)
        manitteeBackView.snp.makeConstraints {
            $0.top.equalTo(informationTitleLabel.snp.bottom).offset(31)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.trailing.equalTo(view.snp.centerX).offset(-14)
            $0.height.equalTo((UIScreen.main.bounds.width-28-40)/2)
        }
        
        manitteeBackView.addSubview(manitteeImageView)
        manitteeImageView.snp.makeConstraints {
            $0.top.equalTo(manitteeBackView.snp.top).inset(16)
            $0.centerX.equalTo(manitteeBackView)
            $0.width.height.equalTo(99)
        }
        
        manitteeBackView.addSubview(manitteeIconView)
        manitteeIconView.snp.makeConstraints {
            $0.centerX.equalTo(manitteeImageView)
            $0.centerY.equalTo(manitteeImageView.snp.centerY)
            $0.width.height.equalTo(90)
        }
        
        manitteeBackView.addSubview(manitteeLabel)
        manitteeLabel.snp.makeConstraints {
            $0.bottom.equalTo(manitteeBackView.snp.bottom).inset(15)
            $0.centerX.equalTo(manitteeBackView)
        }
        
        manitteeBackView.addSubview(manitteeAnimationLabel)
        manitteeAnimationLabel.snp.makeConstraints {
            $0.bottom.equalTo(manitteeBackView.snp.bottom).inset(15)
            $0.centerX.equalTo(manitteeBackView)
        }
        
        view.addSubview(listBackView)
        listBackView.snp.makeConstraints {
            $0.top.equalTo(informationTitleLabel.snp.bottom).offset(31)
            $0.leading.equalTo(view.snp.centerX).offset(14)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.height.equalTo((UIScreen.main.bounds.width-28-40)/2)
        }
        
        listBackView.addSubview(listImageView)
        listImageView.snp.makeConstraints {
            $0.top.equalTo(listBackView.snp.top).inset(16)
            $0.centerX.equalTo(listBackView)
            $0.width.height.equalTo(99)
        }

        listBackView.addSubview(listIconView)
        listIconView.snp.makeConstraints {
            $0.centerX.equalTo(listImageView)
            $0.centerY.equalTo(listImageView.snp.centerY)
            $0.width.height.equalTo(80)
        }
        
        listBackView.addSubview(listLabel)
        listLabel.snp.makeConstraints {
            $0.bottom.equalTo(listBackView.snp.bottom).inset(15)
            $0.centerX.equalTo(listBackView)
        }
        
        view.addSubview(letterBoxButton)
        letterBoxButton.snp.makeConstraints {
            $0.top.equalTo(manitteeBackView.snp.bottom).offset(25)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.height.equalTo(80)
        }
        
        view.addSubview(manittoMemoryButton)
        manittoMemoryButton.snp.makeConstraints {
            $0.top.equalTo(letterBoxButton.snp.bottom).offset(18)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.height.equalTo(80)
        }
        
        view.addSubview(manittoOpenButtonShadowView)
        manittoOpenButtonShadowView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(7)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        manittoOpenButtonShadowView.addSubview(manittoOpenButton)
        manittoOpenButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(manitiRealIconView)
        manitiRealIconView.snp.makeConstraints {
            $0.top.equalTo(manitteeIconView.snp.top)
            $0.trailing.equalTo(manitteeIconView.snp.trailing)
            $0.leading.equalTo(manitteeIconView.snp.leading)
            $0.bottom.equalTo(manitteeIconView.snp.bottom)
        }

        view.addSubview(badgeLabel)
        badgeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(35)
            $0.centerY.equalTo(letterBoxButton).offset(-10)
            $0.width.height.equalTo(30)
        }

        self.view.addSubview(self.guideView)
        self.guideView.snp.makeConstraints {
            $0.top.equalTo(self.missionBackgroundView.snp.top)
            $0.trailing.equalTo(self.missionBackgroundView.snp.trailing)
        }
        self.guideView.setupGuideViewLayout()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let rightItem = makeBarButtonItem(with: exitButton)
        navigationItem.rightBarButtonItem = rightItem
    }

    override func endEditingView() {
        self.guideView.didTapAroundToHideGuideView()
    }
    
    // MARK: - func
    
    private func setupLargeTitleToOriginal() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupProcessingUI() {
        missionBackgroundView.makeBorderLayer(color: .subOrange)
        statusLabel.text = TextLiteral.doing
        statusLabel.backgroundColor = .mainRed
        manittoMemoryButton.isHidden = true
        exitButton.isHidden = true
    }
    
    private func setupPostUI() {
        missionBackgroundView.makeBorderLayer(color: .darkGrey001)
        statusLabel.text = TextLiteral.done
        statusLabel.backgroundColor = .grey002
        manittoMemoryButton.isHidden = false
        exitButton.isHidden = false
        missionContentsLabel.attributedText = NSAttributedString(string: TextLiteral.detailIngViewControllerDoneMissionText)
    }

    private func setupManittoOpenButton(date: String) {
        guard let endDate = date.stringToDateYYYY() else { return }
        manittoOpenButtonShadowView.isHidden = !(endDate.isOpenManitto)
    }
    
    private func setupBadge(count: Int) {
        if count > 0 {
            badgeLabel.isHidden = false
            badgeLabel.countLabel.text = String(count)
        } else {
            badgeLabel.isHidden = true
        }
    }
    
    private func openManittee(manitteeName: String ) {
            let storyboard = UIStoryboard(name: "Interaction", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: SelectManittoViewController.className) as? SelectManittoViewController else { return }
            viewController.modalPresentationStyle = .fullScreen
            viewController.roomId = roomId
            viewController.manitteeName = manitteeName
            present(viewController, animated: true)
    }
    
    private func setupExitButton(admin: Bool) {
        if admin {
            let menu = UIMenu(options: [], children: [
                UIAction(title: TextLiteral.detailWaitViewControllerDeleteRoom, handler: { [weak self] _ in
                    self?.makeRequestAlert(title: TextLiteral.detailIngViewControllerDoneExitAlertAdminTitle, message: TextLiteral.detailIngViewControllerDoneExitAlertAdmin, okAction: { _ in
                        self?.requestDeleteRoom()
                    })
                })
            ])
            exitButton.menu = menu
        } else {
            let menu = UIMenu(options: [], children: [
                UIAction(title: TextLiteral.detailWaitViewControllerLeaveRoom, handler: { [weak self] _ in
                    self?.makeRequestAlert(title: TextLiteral.detailIngViewControllerDoneExitAlertTitle, message: TextLiteral.detailIngViewControllerDoneExitAlertMessage, okAction: { _ in
                        self?.requestExitRoom()
                    })
                })
            ])
            exitButton.menu = menu
        }
    }
    
    func pushNavigationAfterRequestRoomInfo() {
        Task {
            do {
                let data = try await detailIngService.requestStartingRoomInfo(roomId: roomId)
                if let info = data {
                    guard let state = info.roomInformation?.state,
                          let mission = info.mission?.content,
                          let missionId = info.mission?.id
                    else { return }
                    let viewController = LetterViewController(roomState: state,
                                                              roomId: self.roomId,
                                                              mission: mission,
                                                              missionId: missionId.description,
                                                              letterState: .received)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
  
    // MARK: - selector
    
    @objc
    private func didTappedManittee() {
        if !isTappedManittee {
            self.isTappedManittee = true
            UIView.animate(withDuration: 1.0) {
                self.toggledManitteeAnimation(self.isTappedManittee)
            } completion: { _ in
                UIView.animate(withDuration: 1.0, delay: 0.5) {
                    self.toggledManitteeAnimation(!self.isTappedManittee)
                } completion: { _ in
                    self.isTappedManittee = false
                }
            }
        }
    }
    
    private func toggledManitteeAnimation(_ value: Bool) {
        manitteeLabel.alpha = value ? 0 : 1
        manitteeIconView.alpha = value ? 0 : 1
        manitiRealIconView.alpha = value ? 1 : 0
        manitteeAnimationLabel.alpha = value ? 1 : 0
    }
    
    // FIXME: - 추후 PR 때, friendslistViewController codebase로 만들 예정
    @objc
    private func pushFriendListViewController(_ gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "DetailIng", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: FriendListViewController.className) as? FriendListViewController else { return }
        guard let roomId = Int(roomId) else { return }
        viewController.roomIndex = roomId
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - DetailStarting API
   
    private func requestRoomInfo() {
        Task {
            do {
                let data = try await detailIngService.requestStartingRoomInfo(roomId: roomId)
                if let info = data {
                    guard let state = data?.roomInformation?.state,
                          let title = info.roomInformation?.title,
                          let startDate = info.roomInformation?.startDate,
                          let endDate = info.roomInformation?.endDate,
                          let manittee = info.manittee?.nickname,
                          let admin = info.admin,
                          let badgeCount = info.messages?.count
                    else { return }
                    
                    roomType = RoomType.init(rawValue: state) ?? .PROCESSING
                    missionId = info.mission?.id?.description ?? ""
                    
                    DispatchQueue.main.async {
                        self.titleLabel.text = title
                        self.periodLabel.text = "\(startDate.subStringToDate()) ~ \(endDate.subStringToDate())"
                        self.manitteeAnimationLabel.text = manittee
                        self.setupBadge(count: badgeCount)
                        
                        if self.roomType == .PROCESSING {
                            self.setupProcessingUI()
                            guard let missionContent = info.mission?.content,
                                  let didView = info.didViewRoulette
                            else { return }
                            self.missionContentsLabel.attributedText = NSAttributedString(string: missionContent)
                            if !didView && !admin {
                                self.openManittee(manitteeName: manittee)
                            }
                            self.setupManittoOpenButton(date: endDate)
                        } else {
                            self.setupPostUI()
                            self.setupExitButton(admin: admin)
                        }
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
    
    private func requestExitRoom() {
        Task {
            do {
                let statusCode = try await detailDoneService.requestExitRoom(roomId: roomId)
                if statusCode == 204 {
                    navigationController?.popViewController(animated: true)
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
                makeAlert(title: TextLiteral.detailIngViewControllerDoneExitAlertAdmin)
            }
        }
    }
    
    private func requestDeleteRoom() {
        Task {
            do {
                let statusCode = try await detailDoneService.requestDeleteRoom(roomId: roomId)
                if statusCode == 204 {
                    navigationController?.popViewController(animated: true)
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

