//
//  ChooseRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/18.
//

import UIKit

import SnapKit

final class ChooseCharacterViewController: BaseViewController {
    
    enum Status {
        case createRoom
        case enterRoom
    }
    
    // MARK: - ui component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.chooseCharacterViewControllerTitleLabel
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.chooseCharacterViewControllerSubTitleLabel
        label.font = .font(.regular, ofSize: 18)
        label.textColor = .grey002
        return label
    }()
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    private let manittoCollectionView: CharacterCollectionView = CharacterCollectionView()
    private lazy var enterButton: MainButton = {
        let button = MainButton()
        switch statusMode {
        case .createRoom:
            button.title = TextLiteral.createRoom
        case .enterRoom:
            button.title = TextLiteral.enterRoom
        }
        let action = UIAction { [weak self] _ in
            self?.didTapEnterButton()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.icBack, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 14)
        button.tintColor = .white
        let action = UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    // MARK: - property
    
    private let roomService: RoomProtocol = RoomAPI(apiService: APIService())
    private var statusMode: Status
    private var roomId: Int?
    private var colorIdx: Int = 0
    var roomInfo: RoomDTO?
    
    // MARK: - init
    
    init(statusMode: Status, roomId: Int?) {
        self.statusMode = statusMode
        self.roomId = roomId
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - override
    
    override func setupLayout() {
        self.view.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.view.addSubview(self.subTitleLabel)
        self.subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.view.addSubview(self.backButton)
        self.backButton.snp.makeConstraints {
            $0.top.equalTo(self.closeButton)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.view.addSubview(self.enterButton)
        self.enterButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalToSuperview().inset(57)
            $0.height.equalTo(60)
        }
        
        self.view.addSubview(self.manittoCollectionView)
        self.manittoCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.enterButton.snp.top)
        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - func
    
    private func didTapEnterButton() {
        switch self.statusMode {
        case .createRoom:
            guard let roomInfo = self.roomInfo else { return }
            self.requestCreateRoom(room: CreateRoomDTO(room: RoomDTO(title: roomInfo.title,
                                                                capacity: roomInfo.capacity,
                                                                startDate: roomInfo.startDate,
                                                                endDate: roomInfo.endDate) ,
                                                  member: MemberDTO(colorIdx: colorIdx)))
        case .enterRoom:
            self.requestJoinRoom()
        }
    }
    
    // MARK: - network
    
    private func requestJoinRoom() {
        Task {
            do {
                guard let id = self.roomId else { return }
                let status = try await self.roomService.dispatchJoinRoom(roodId: id.description,
                                                                         dto: MemberDTO(colorIdx: self.colorIdx))
                if status == 201 {
                    guard let navigationController = self.presentingViewController as? UINavigationController else { return }
                    guard let id = self.roomId else { return }
                    let viewController = DetailWaitViewController(index: id)
                    self.dismiss(animated: true) {
                        navigationController.pushViewController(viewController, animated: true)
                    }
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
                self.makeAlert(title: "이미 참여중인 방입니다", message: "참여중인 애니또 리스트를 확인해 보세요", okAction: { [weak self] _ in
                    self?.dismiss(animated: true)
                })
            }
        }
    }
    
    func requestCreateRoom(room: CreateRoomDTO) {
        Task {
            do {
                guard
                    let roomId = try await self.roomService.postCreateRoom(body: room),
                    let navigationController = self.presentingViewController as? UINavigationController
                else { return }
                let viewController = DetailWaitViewController(index: roomId)
                navigationController.popViewController(animated: true)
                navigationController.pushViewController(viewController, animated: false)
                
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: .createRoomInvitedCode, object: nil)
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
