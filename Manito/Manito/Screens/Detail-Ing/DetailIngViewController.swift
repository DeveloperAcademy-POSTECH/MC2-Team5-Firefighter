//
//  DetailIngViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class DetailIngViewController: BaseViewController {
    
    private enum RoomType: String {
        case PROCESSING
        case POST
    }
    
    lazy var detailIngService: DetailIngAPI = DetailIngAPI(apiService: APIService())
    lazy var detailDoneService: DetailDoneAPI = DetailDoneAPI(apiService: APIService())

    var friendList: FriendList?
    var roomInformation: ParticipatingRoom? {
        willSet {
            guard let state = newValue?.state else { return }
            roomType = RoomType.init(rawValue: state)
        }
    }
    var isTappedManittee: Bool = false
    var isAdminPost: Bool = false {
        didSet {
            exitButton.menu = setEllipsisMenu()
        }
    }

    // MARK: - property

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var missionBackgroundView: UIView!
    @IBOutlet weak var missionTitleLabel: UILabel!
    @IBOutlet weak var missionContentsLabel: UILabel!
    @IBOutlet weak var informationTitleLabel: UILabel!
    @IBOutlet weak var manitteeBackView: UIView!
    @IBOutlet weak var manitteeImageView: UIView!
    @IBOutlet weak var manitteeIconView: UIImageView!
    @IBOutlet weak var manitteeLabel: UILabel!
    @IBOutlet weak var listBackView: UIView!
    @IBOutlet weak var listImageView: UIView!
    @IBOutlet weak var listIconView: UIImageView!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var letterBoxButton: UIButton!
    @IBOutlet weak var manitoMemoryButton: UIButton!
    @IBOutlet weak var manitteeAnimationLabel: UILabel!

    private let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.icMore, for: .normal)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    private lazy var manitiRealIconView: UIImageView = {
        let imageView = UIImageView(image: ImageLiterals.imgMa)
        imageView.alpha = 0
        return imageView
    }()
    
    private let manitoOpenButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.detailIngViewControllerManitoOpenButton
        return button
    }()
    
    private let badgeLabel: LetterCountBadgeView = {
        let label = LetterCountBadgeView()
        label.layer.cornerRadius = 15
        label.isHidden = true
        return label
    }()
    
    private var roomType: RoomType? {
        didSet {
            if roomType == .POST {
                exitButton.isHidden = false
            } else {
                exitButton.isHidden = true
            }
        }
    }
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }

    // MARK: - life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLargeTitleToOriginal()
        switch roomType {
        case .POST:
            requestDoneRoomInfo()
        case .PROCESSING:
            requestRoomInfo()
            setupOpenManittoButton()
        case .none: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGuideArea()
        renderGuideArea()
    }

    override func render() {
        view.addSubview(manitoOpenButton)
        manitoOpenButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(7)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(manitiRealIconView)
        manitiRealIconView.snp.makeConstraints {
            $0.top.equalTo(manitteeIconView.snp.top)
            $0.trailing.equalTo(manitteeIconView.snp.trailing)
            $0.leading.equalTo(manitteeIconView.snp.leading)
            $0.bottom.equalTo(manitteeIconView.snp.bottom)
        }
        
        view.addSubview(guideButton)
        guideButton.snp.makeConstraints {
            $0.top.equalTo(missionBackgroundView.snp.top)
            $0.trailing.equalTo(missionBackgroundView.snp.trailing)
            $0.width.height.equalTo(44)
        }
        
        view.addSubview(badgeLabel)
        badgeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(35)
            $0.centerY.equalTo(letterBoxButton).offset(-10)
            $0.width.height.equalTo(30)
        }
    }

    override func configUI() {
        super.configUI()
        setupFont()
        setupViewLayer()
        setupStatusLabel()
        setupManitteLabel()
        
        addActionMemoryViewController()
        addActionPushLetterViewController()
        addGestureMemberList()
        addGestureManito()
        addActionOpenManittoViewController()
        
        manitteeLabel.text = "\(UserDefaultStorage.nickname ?? "당신")의 마니띠"
        manitteeIconView.image = ImageLiterals.icManiTti
        listIconView.image = ImageLiterals.icList
    }
    
    override func setupGuideArea() {
        super.setupGuideArea()
        guideButton.setImage(ImageLiterals.icMissionInfo, for: .normal)
        setupGuideText(title: TextLiteral.detailIngViewControllerGuideTitle, text: TextLiteral.detailIngViewControllerText)
    }
    
    override func setupNavigationBar() {
        let rightItem = makeBarButtonItem(with: exitButton)
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func setupLargeTitleToOriginal() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }

    private func setupFont() {
        titleLabel.font = .font(.regular, ofSize: 34)
        periodLabel.font = .font(.regular, ofSize: 16)
        statusLabel.font = .font(.regular, ofSize: 13)
        missionTitleLabel.font = .font(.regular, ofSize: 14)
        missionContentsLabel.font = .font(.regular, ofSize: 18)
        informationTitleLabel.font = .font(.regular, ofSize: 16)
        manitteeLabel.font = .font(.regular, ofSize: 15)
        manitteeAnimationLabel.font = .font(.regular, ofSize: 15)
        listLabel.font = .font(.regular, ofSize: 15)
        letterBoxButton.titleLabel?.font = .font(.regular, ofSize: 15)
        manitoMemoryButton.titleLabel?.font = .font(.regular, ofSize: 15)
    }

    private func setupViewLayer() {
        missionBackgroundView.layer.cornerRadius = 10
        missionBackgroundView.layer.borderWidth = 1
        if roomType == .POST {
            missionBackgroundView.layer.borderColor = UIColor.white.cgColor
            manitoMemoryButton.layer.isHidden = false
            manitoOpenButton.layer.isHidden = true
        } else {
            missionBackgroundView.layer.borderColor = UIColor.systemYellow.cgColor
            manitoMemoryButton.layer.isHidden = true
            manitoOpenButton.layer.isHidden = false
        }
        manitteeBackView.makeBorderLayer(color: .white)
        manitteeImageView.layer.cornerRadius = manitteeImageView.bounds.size.width / 2
        listBackView.makeBorderLayer(color: .white)
        listImageView.layer.cornerRadius = listImageView.bounds.size.width / 2
        letterBoxButton.makeBorderLayer(color: .white)
        manitoMemoryButton.makeBorderLayer(color: .white)
    }
    
    private func setupStatusLabel() {
        statusLabel.text = roomType == .POST ? TextLiteral.done : TextLiteral.doing
        statusLabel.backgroundColor = roomType == .POST ? .grey002 : .mainRed
        statusLabel.layer.masksToBounds = true
        statusLabel.layer.cornerRadius = 11
        statusLabel.textColor = .white
        statusLabel.font = .font(.regular, ofSize: 13)
        statusLabel.textAlignment = .center
    }
    
    private func setupManitteLabel() {
        manitteeAnimationLabel.text = ""
        manitteeAnimationLabel.alpha = 0
    }
    
    private func addGestureManito() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedManittee))
        manitteeBackView.addGestureRecognizer(tapGesture)
    }
    
    private func addGestureMemberList() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushFriendListViewController(_:)))
        listBackView.addGestureRecognizer(tapGesture)
    }
    
    private func addActionPushLetterViewController() {
        let action = UIAction { [weak self] _ in
            guard let roomType = self?.roomType,
                  let roomId = self?.roomInformation?.id,
                  let mission = self?.missionContentsLabel.text
            else { return }
            let letterViewController = LetterViewController(roomState: roomType.rawValue,
                                                            roomId: roomId.description,
                                                            mission: mission,
                                                            letterState: .sent)
            self?.navigationController?.pushViewController(letterViewController, animated: true)
        }
        letterBoxButton.addAction(action, for: .touchUpInside)
    }
    
    private func addActionMemoryViewController() {
        let action = UIAction { [weak self] _ in
            guard let roomId = self?.roomInformation?.id else { return }
            let viewController = MemoryViewController(roomId: roomId.description)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        manitoMemoryButton.addAction(action, for: .touchUpInside)
    }
    
    private func addActionOpenManittoViewController() {
        guard let id = roomInformation?.id?.description else { return }
        let action = UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(OpenManittoViewController(roomId: id), animated: true)
        }
        self.manitoOpenButton.addAction(action, for: .touchUpInside)
    }
    
    private func setupOpenManittoButton() {
        guard let endDateToString = roomInformation?.endDate else { return }
        guard let endDate = endDateToString.stringToDateYYYY() else { return }

        manitoOpenButton.isHidden = !endDate.isOpenManitto
    }
    
    private func setEllipsisMenu() -> UIMenu {
        let menu = UIMenu(options: [], children: [
            UIAction(title: isAdminPost ? TextLiteral.detailWaitViewControllerDeleteRoom : TextLiteral.detailWaitViewControllerLeaveRoom, handler: { [weak self] _ in
                if let isAdmin = self?.isAdminPost {
                    if isAdmin {
                        self?.makeRequestAlert(title: TextLiteral.detailIngViewControllerDoneExitAlertAdminTitle, message: TextLiteral.detailIngViewControllerDoneExitAlertAdmin, okAction: { _ in
                            self?.requestDeleteRoom()
                        })
                    } else {
                        self?.makeRequestAlert(title: TextLiteral.detailIngViewControllerDoneExitAlertTitle, message: TextLiteral.detailIngViewControllerDoneExitAlertMessage, okAction: { _ in
                            self?.requestExitRoom()
                        })
                    }
                }
            })
        ])
        return menu
    }
    
    // MARK: - DetailStarting API
    
    private func requestRoomInfo() {
        Task {
            do {
                guard let roomId = roomInformation?.id?.description else { return }
                let data = try await detailIngService.requestStartingRoomInfo(roomId: roomId)
                if let info = data {
                    titleLabel.text = info.room?.title
                    guard let startDate = info.room?.startDate,
                          let endDate = info.room?.endDate,
                          let missionContent = info.mission?.content,
                          let manittee = info.manittee?.nickname,
                          let didView = info.didViewRoulette,
                          let admin = info.admin,
                          let badgeCount = info.messages?.count
                    else { return }
                    periodLabel.text = "\(startDate.subStringToDate()) ~ \(endDate.subStringToDate())"
                    missionContentsLabel.text = missionContent
                    manitteeAnimationLabel.text = manittee
                    if badgeCount > 0 {
                        badgeLabel.isHidden = false
                        badgeLabel.countLabel.text = String(badgeCount)
                    } else {
                        badgeLabel.isHidden = true
                    }
                    
                    if !didView && !admin {
                        let storyboard = UIStoryboard(name: "Interaction", bundle: nil)
                        guard let viewController = storyboard.instantiateViewController(withIdentifier: SelectManittoViewController.className) as? SelectManittoViewController else { return }
                        viewController.modalPresentationStyle = .fullScreen
                        viewController.roomId = roomInformation?.id?.description
                        viewController.manitteeName = manittee
                        present(viewController, animated: true)
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
    
    private func requestWithFriends() {
        Task {
            do {
                guard let roomId = roomInformation?.id?.description else { return }
                let data = try await detailIngService.requestWithFriends(roomId: roomId)
                if let list = data {
                    friendList = list
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
    
    // MARK: - DetailDone API
    
    private func requestDoneRoomInfo() {
        Task {
            do {
                guard let roomId = roomInformation?.id?.description else { return }
                let data = try await detailDoneService.requestDoneRoomInfo(roomId: roomId)
                if let info = data {
                    titleLabel.text = info.room?.title
                    guard let startDate = info.room?.startDate,
                          let endDate = info.room?.endDate,
                          let minittee = info.manittee?.nickname,
                          let isAdmin = info.admin
                    else { return }
                    isAdminPost = isAdmin
                    periodLabel.text = "\(startDate.subStringToDate()) ~ \(endDate.subStringToDate())"
                    manitteeAnimationLabel.text = minittee
                    missionContentsLabel.text = TextLiteral.detailIngViewControllerDoneMissionText
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
    
    private func requestMemory() {
        Task {
            do {
                guard let roomId = roomInformation?.id?.description else { return }
                let data = try await detailDoneService.requestMemory(roomId: roomId)
                if let _ = data {
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
                guard let roomId = roomInformation?.id?.description else { return }
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
                guard let roomId = roomInformation?.id?.description else { return }
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
    
    // MARK: - selector
    
    @objc
    private func pushFriendListViewController(_ gesture: UITapGestureRecognizer) {
        requestWithFriends()
        let storyboard = UIStoryboard(name: "DetailIng", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: FriendListViewController.className) as? FriendListViewController else { return }
        guard let roomId = roomInformation?.id else { return }
        viewController.roomIndex = roomId
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func toggledManitteeAnimation(_ value: Bool) {
        manitteeLabel.alpha = value ? 0 : 1
        manitteeIconView.alpha = value ? 0 : 1
        manitiRealIconView.alpha = value ? 1 : 0
        manitteeAnimationLabel.alpha = value ? 1 : 0
    }
    
    @objc
    private func didTappedManittee() {
        if !isTappedManittee {
            self.isTappedManittee = true
            UIView.animate(withDuration: 1.0) {
                self.toggledManitteeAnimation(self.isTappedManittee)
            } completion: { _ in
                UIView.animate(withDuration: 1.0, delay: 0.5) {
                    self.toggledManitteeAnimation(!self.isTappedManittee)
                    self.manitteeLabel.text = "\(UserDefaultStorage.nickname ?? "당신")의 마니띠"
                } completion: { _ in
                    self.isTappedManittee = false
                }
            }
        }
    }
    
    @objc
    override func endEditingView() {
        if !guideButton.isTouchInside {
            guideBoxImageView.isHidden = true
        }
    }
}
