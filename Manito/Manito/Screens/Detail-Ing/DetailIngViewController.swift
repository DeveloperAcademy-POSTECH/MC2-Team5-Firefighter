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
            roomType = RoomType(rawValue: state)
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
    @IBOutlet weak var manitiBackView: UIView!
    @IBOutlet weak var manitiImageView: UIView!
    @IBOutlet weak var manitiIconView: UIImageView!
    @IBOutlet weak var manitiLabel: UILabel!
    @IBOutlet weak var listBackView: UIView!
    @IBOutlet weak var listImageView: UIView!
    @IBOutlet weak var listIconView: UIImageView!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var letterBoxButton: UIButton!
    @IBOutlet weak var manitoMemoryButton: UIButton!
    @IBOutlet weak var manitteAnimationLabel: UILabel!

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
    
    private var roomType: RoomType?
    
    deinit {
        print("detailing view controller is dead")
    }

    // MARK: - life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            $0.top.equalTo(manitiIconView.snp.top)
            $0.trailing.equalTo(manitiIconView.snp.trailing)
            $0.leading.equalTo(manitiIconView.snp.leading)
            $0.bottom.equalTo(manitiIconView.snp.bottom)
        }
        
        view.addSubview(guideButton)
        guideButton.snp.makeConstraints {
            $0.top.equalTo(missionBackgroundView.snp.top)
            $0.trailing.equalTo(missionBackgroundView.snp.trailing)
            $0.width.height.equalTo(44)
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
        
        manitiIconView.image = ImageLiterals.icManiTti
        listIconView.image = ImageLiterals.icList
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func setupGuideArea() {
        super.setupGuideArea()
        guideButton.setImage(ImageLiterals.icMissionInfo, for: .normal)
        setupGuideText(title: TextLiteral.detailIngViewControllerGuideTitle, text: TextLiteral.detailIngViewControllerText)
    }

    private func setupFont() {
        titleLabel.font = .font(.regular, ofSize: 34)
        periodLabel.font = .font(.regular, ofSize: 16)
        statusLabel.font = .font(.regular, ofSize: 13)
        missionTitleLabel.font = .font(.regular, ofSize: 14)
        missionContentsLabel.font = .font(.regular, ofSize: 18)
        informationTitleLabel.font = .font(.regular, ofSize: 16)
        manitiLabel.font = .font(.regular, ofSize: 15)
        manitteAnimationLabel.font = .font(.regular, ofSize: 15)
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
        manitiBackView.makeBorderLayer(color: .white)
        manitiImageView.layer.cornerRadius = 50
        listBackView.makeBorderLayer(color: .white)
        listImageView.layer.cornerRadius = 50
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
        manitteAnimationLabel.text = ""
        manitteAnimationLabel.alpha = 0
    }
    
    private func addGestureManito() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapManito))
        manitiBackView.addGestureRecognizer(tapGesture)
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
            let letterViewController = LetterViewController(roomState: roomType.rawValue, roomId: roomId.description, mission: mission)
            self?.navigationController?.pushViewController(letterViewController, animated: true)
        }
        letterBoxButton.addAction(action, for: .touchUpInside)
    }
    
    private func addActionMemoryViewController() {
        let action = UIAction { [weak self] _ in
            let storyboard = UIStoryboard(name: "DetailIng", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: MemoryViewController.className) as? MemoryViewController else { return }
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        manitoMemoryButton.addAction(action, for: .touchUpInside)
    }
    
    private func addActionOpenManittoViewController() {
        guard let id = roomInformation?.id else { return }
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
                          let minittee = info.manittee?.nickname,
                          let didView = info.didViewRoulette,
                          let manitto = info.manitto?.nickname
                    else { return }
                    periodLabel.text = "\(startDate.subStringToDate()) ~ \(endDate.subStringToDate())"
                    missionContentsLabel.text = missionContent
                    manitteAnimationLabel.text = minittee
                    if !didView {
                        let storyboard = UIStoryboard(name: "Interaction", bundle: nil)
                        guard let viewController = storyboard.instantiateViewController(withIdentifier: SelectManittoViewController.className) as? SelectManittoViewController else { return }
                        viewController.modalPresentationStyle = .fullScreen
                        viewController.roomInformation = roomInformation
                        viewController.manittiName = manitto
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
                          let minittee = info.manittee?.nickname
                    else { return }
                    periodLabel.text = "\(startDate.subStringToDate()) ~ \(endDate.subStringToDate())"
                    manitteAnimationLabel.text = minittee
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
    
    @objc
    private func didTapManito() {
        UIView.animate(withDuration: 2.0) {
            self.manitiLabel.alpha = 0
            self.manitiIconView.alpha = 0
            self.manitiRealIconView.alpha = 1
            self.manitteAnimationLabel.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 1.0) {
                self.manitiIconView.alpha = 1
                self.manitiRealIconView.alpha = 0
                self.manitiLabel.text = "호야의 마니띠"
                self.manitteAnimationLabel.alpha = 0
                self.manitiLabel.alpha = 1
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
