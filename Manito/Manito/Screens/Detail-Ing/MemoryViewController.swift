//
//  MemoryViewController.swift
//  Manito
//
//  Created by 최성희 on 2022/06/14.
//

import UIKit

import SnapKit

final class MemoryViewController: UIViewController, BaseViewControllerType, Navigationable {
    
    private enum MemoryType: Int {
        case manittee = 0
        case manitto = 1
        
        var announcingText: String {
            switch self {
            case .manittee:
                return TextLiteral.memoryViewControllerManitteeText
            case .manitto:
                return TextLiteral.memoryViewControllerManittoText
            }
        }
    }
    
    private enum Size {
        static let lineSpacing: CGFloat = 10.0
        static let margin: CGFloat = 16.0
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - (margin * 2 + lineSpacing)) / 2
        static let cellHeight: CGFloat = cellWidth * 0.9
        static let collectionViewHeight: CGFloat = cellHeight * 2 + lineSpacing
    }
    
    // MARK: - properties
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.Icon.insta, for: .normal)
        return button
    }()
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [TextLiteral.letterHeaderViewSegmentControlManitti, TextLiteral.letterHeaderViewSegmentControlManitto])
        let font = UIFont.font(.regular, ofSize: 14)
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: font]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: font]
        
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        control.selectedSegmentTintColor = .white
        control.backgroundColor = .darkGrey004
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(changedIndexValue(_:)), for: .valueChanged)
        
        return control
    }()
    private let shareBoundView = UIView()
    private let announcementLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 30)
        return label
    }()
    private lazy var memoryCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        flowLayout.minimumLineSpacing = Size.lineSpacing
        flowLayout.minimumInteritemSpacing = Size.lineSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: Size.margin, bottom: 0, right: Size.margin)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(MemoryCollectionViewCell.self, forCellWithReuseIdentifier: MemoryCollectionViewCell.className)
        return collectionView
    }()
    private let manittoTopImageView = UIImageView(image: UIImage.Image.characters)
    private let manittoBottomImageView = UIImageView(image: UIImage.Image.characters)
    private let characterImageView = UIImageView()
    private let characterBackView: UIView = {
        let view = UIView()
        view.makeBorderLayer(color: .white)
        view.layer.cornerRadius = 49.5
        return view
    }()
    
    private var detailRoomRepository: DetailRoomRepository = DetailRoomRepositoryImpl()
    private var memoryType: MemoryType = .manittee {
        willSet {
            setupData(with: newValue)
            self.memoryCollectionView.reloadData()
        }
    }
    private var memory: MemoryDTO?
    private var roomId: String
    
    // MARK: - init
    
    init(roomId: String) {
        self.roomId = roomId
        super.init(nibName: nil, bundle: nil)
        requestMemory(roomId: roomId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseViewDidLoad()
        self.setupNavigation()
    }
    
    // MARK: - base func
    
    func setupLayout() {
        view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
            $0.width.equalTo(294)
        }
        
        view.addSubview(shareBoundView)
        shareBoundView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(31)
        }
        
        shareBoundView.addSubview(manittoTopImageView)
        manittoTopImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(40)
        }
        
        shareBoundView.addSubview(announcementLabel)
        announcementLabel.snp.makeConstraints {
            $0.top.equalTo(manittoTopImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        shareBoundView.addSubview(memoryCollectionView)
        memoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(announcementLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Size.collectionViewHeight)
        }
        
        shareBoundView.addSubview(manittoBottomImageView)
        manittoBottomImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(40)
        }
        
        shareBoundView.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints {
            $0.bottom.equalTo(manittoBottomImageView.snp.top).offset(-30)
            $0.centerX.equalToSuperview()
        }
        
        shareBoundView.addSubview(characterBackView)
        characterBackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(memoryCollectionView.snp.centerY)
            $0.width.height.equalTo(99)
        }
        
        characterBackView.addSubview(characterImageView)
        characterImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(90)
        }
    }

    func configureUI() {
        self.view.backgroundColor = .backgroundGrey
        self.setupAction()
        self.setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let shareButton = makeBarButtonItem(with: shareButton)
        
        self.navigationItem.rightBarButtonItem = shareButton
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.title = TextLiteral.memoryViewControllerTitleLabel
    }

    // MARK: - func
    
    private func setupAction() {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            
            if let storyShareURL = URL(string: "instagram-stories://share") {
                if UIApplication.shared.canOpenURL(storyShareURL) {
                    let renderer = UIGraphicsImageRenderer(size: self.shareBoundView.bounds.size)
                    let renderImage = renderer.image { _ in
                        self.shareBoundView.drawHierarchy(in: self.shareBoundView.bounds, afterScreenUpdates: true)
                    }
                    guard let imageData = renderImage.pngData() else {return}
                    let pasteboardItems: [String: Any] = [
                        "com.instagram.sharedSticker.stickerImage": imageData
                    ]
                    let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)]
                    
                    UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                    UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)
                } else {
                    self.makeAlert(title: TextLiteral.memoryViewControllerAlertTitle,
                                   message: TextLiteral.memoryViewControllerAlertMessage)
                }
            }
        }
        shareButton.addAction(action, for: .touchUpInside)
    }
    
    // MARK: - network
    
    private func setupData(with state: MemoryType) {
        announcementLabel.text = state.announcingText
        switch state {
        case .manittee:
            guard let manitteeColorIndex = memory?.memoriesWithManittee?.member?.colorIndex else { return }
            nicknameLabel.text = memory?.memoriesWithManittee?.member?.nickname
            characterBackView.backgroundColor = DefaultCharacterType.allCases[manitteeColorIndex].backgroundColor
            characterImageView.image = DefaultCharacterType.allCases[manitteeColorIndex].image
        case .manitto:
            guard let manittoColorIndex = memory?.memoriesWithManitto?.member?.colorIndex else { return }
            nicknameLabel.text = memory?.memoriesWithManitto?.member?.nickname
            characterBackView.backgroundColor = DefaultCharacterType.allCases[manittoColorIndex].backgroundColor
            characterImageView.image = DefaultCharacterType.allCases[manittoColorIndex].image
        }
    }
    
    private func requestMemory(roomId: String) {
        Task {
            do {
                let data = try await self.detailRoomRepository.fetchMemory(roomId: roomId)
                self.memory = data
                self.setupData(with: .manittee)
                self.memoryCollectionView.reloadData()
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
    private func changedIndexValue(_ sender: UISegmentedControl) {
        segmentControl.selectedSegmentIndex = sender.selectedSegmentIndex
        memoryType = MemoryType(rawValue: sender.selectedSegmentIndex) ?? .manittee
    }
}

extension MemoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch memoryType {
        case .manittee:
            guard let count = memory?.memoriesWithManittee?.messages?.count else { return 0 }
            return count
        case .manitto:
            guard let count = memory?.memoriesWithManitto?.messages?.count else { return 0 }
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MemoryCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        var imageUrl: String

        switch memoryType {
        case .manittee:
            imageUrl = memory?.memoriesWithManittee?.messages?[indexPath.item].imageUrl ?? ""
            cell.setData(imageUrl: memory?.memoriesWithManittee?.messages?[indexPath.item].imageUrl,
                         content: memory?.memoriesWithManittee?.messages?[indexPath.item].content)
        case .manitto:
            imageUrl = memory?.memoriesWithManitto?.messages?[indexPath.item].imageUrl ?? ""
            cell.setData(imageUrl: memory?.memoriesWithManitto?.messages?[indexPath.item].imageUrl,
                         content: memory?.memoriesWithManitto?.messages?[indexPath.item].content)
        }

        cell.didTappedImage = { [weak self] image in
            let viewController = LetterImageViewController(imageUrl: imageUrl)
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .crossDissolve
            self?.present(viewController, animated: true)
        }

        return cell
    }
}
