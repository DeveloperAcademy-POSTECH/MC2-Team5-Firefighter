//
//  ChooseRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/18.
//

import UIKit

import SnapKit

class ChooseCharacterViewController: BaseViewController {
    
    let roomService: RoomProtocol = RoomAPI(apiService: APIService(), environment: .development)
    
    private enum Size {
        static let leadingTrailingPadding: CGFloat = 20
        static let collectionHorizontalSpacing: CGFloat = 29.0
        static let collectionVerticalSpacing: CGFloat = 37.0
        static let cellInterSpacing: CGFloat = 39.0
        static let cellLineSpacing: CGFloat = 24.0
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - (collectionHorizontalSpacing * 2 + cellInterSpacing * 2)) / 3
        static let collectionInset = UIEdgeInsets(top: collectionVerticalSpacing,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    enum Status {
        case createRoom
        case enterRoom
    }
    
    var statusMode: Status
    var roomInfo: RoomDTO?
    
    private var colorIdx: Int = 0
    
    // MARK: - Property
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
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
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
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(cell: CharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterCollectionViewCell.className)
        return collectionView
    }()
    
    private lazy var enterButton: MainButton = {
        let button = MainButton()
        button.addTarget(self, action: #selector(didTapEnterButton), for: .touchUpInside)
        switch statusMode {
        case .createRoom:
            button.title = TextLiteral.createRoom
        case .enterRoom:
            button.title = TextLiteral.choose
        }
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.icBack, for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.titleLabel?.font = .font(.regular, ofSize: 14)
        button.tintColor = .white
        return button
    }()
    
    init(statusMode: Status) {
        self.statusMode = statusMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(closeButton)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(manittoCollectionView)
        manittoCollectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(enterButton)
        enterButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalToSuperview().inset(57)
            $0.height.equalTo(60)
        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - API
    
    func requestCreateRoom(room: CreateRoomDTO) {
        Task {
            do {
                let _ = try await roomService.postCreateRoom(body: room)
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(message)")
            }
        }
    }
    
    // MARK: - Selectors
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapEnterButton() {
        switch statusMode {
        case .createRoom:
            guard let roomInfo = roomInfo else { return }
            requestCreateRoom(room: CreateRoomDTO(room: RoomDTO(title: roomInfo.title,
                                                                capacity: roomInfo.capacity,
                                                                startDate: roomInfo.startDate,
                                                                endDate: roomInfo.endDate) ,
                                                  member: MemberDTO(colorIdx: colorIdx)))
            guard let navigationController = self.presentingViewController as? UINavigationController else { return }
            let viewController = DetailWaitViewController(index: 12) //FIXME
            navigationController.popViewController(animated: true)
            navigationController.pushViewController(viewController, animated: false)
            
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: .createRoomInvitedCode, object: nil)
            }
        case .enterRoom:
            print("enter")
        }
        
    }
}

// MARK: - UICollectionViewDataSource
extension ChooseCharacterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Character.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CharacterCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.characterBackground = Character.allCases[indexPath.item].color
        cell.characterImageView.image = Character.allCases[indexPath.item].image
        cell.setImageBackgroundColor()
        
        if indexPath.item == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false , scrollPosition: .init())
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ChooseCharacterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택한 마니또 이미지 정보 출력
        colorIdx = indexPath.item
    }
}
