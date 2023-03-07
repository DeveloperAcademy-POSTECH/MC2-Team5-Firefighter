//
//  LetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

enum LetterState: Int {
    case sent = 0
    case received = 1

    var isHidden: Bool {
        switch self {
        case .received:
            return false
        case .sent:
            return true
        }
    }

    var labelText: String {
        switch self {
        case .sent:
            return TextLiteral.letterViewControllerEmptyViewTo
        case .received:
            return TextLiteral.letterViewControllerEmptyViewFrom
        }
    }
}

final class LetterViewController: BaseViewController {

    // MARK: - ui component

    private let letterView: LetterView = LetterView()

    // MARK: - property
    
    private var letterState: LetterState {
        didSet {
            self.letterView.reloadCollectionView(with: self.letterState)
            self.letterView.setupEmptyLabel()
        }
    }
    private var letterList: [Message] = [] {
        didSet {
            self.letterView.updateLetterView()
        }
    }
    private let letterSevice: LetterAPI = LetterAPI(apiService: APIService())
    private var manitteeId: String?
    private var roomId: String
    private var roomState: String
    private var mission: String
    private var missionId: String
    
    // MARK: - init
    
    init(roomState: String, roomId: String, mission: String, missionId: String, letterState: LetterState) {
        self.roomState = roomState
        self.roomId = roomId
        self.mission = mission
        self.missionId = missionId
        self.letterState = letterState
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle

    override func loadView() {
        self.view = self.letterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGuideArea()
        self.renderGuideArea()
        self.hideGuideViewWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.letterView.setupLargeTitle()
    }

    override func viewWillDisappear(_ animated: Bool) {
        // TODO: - 화면 끝날때 어떤 부분들을 reset하고 가야하는지 따로 func를 만들기
        self.guideBoxImageView.isHidden = true
    }

    // MARK: - override

    // TODO: - guide Button이 BaseViewController에 더이상 있으면 안된다! 다른 곳으로 옮기자.
    // 애초에 guidebutton 크기를 여기서 잡는게 맞는가?(위치마다 크기가 달라서..)
    override func setupLayout() {
        self.view.addSubview(self.guideButton)
        self.guideButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let guideButton = self.makeBarButtonItem(with: self.guideButton)
        self.navigationItem.rightBarButtonItem = guideButton
        self.title = TextLiteral.letterViewControllerTitle
    }
    
    override func setupGuideArea() {
        super.setupGuideArea()
        self.guideButton.setImage(ImageLiterals.icLetterInfo, for: .normal)
        self.setupGuideText(title: TextLiteral.letterViewControllerGuideTitle, text: TextLiteral.letterViewControllerGuideText)
    }
    
    override func renderGuideArea() {
        if let navigationView = self.navigationController?.view {
            navigationView.addSubview(self.guideBoxImageView)
            self.guideBoxImageView.snp.makeConstraints {
                $0.top.equalTo(navigationView.safeAreaLayoutGuide.snp.top).inset(35)
                $0.trailing.equalTo(navigationView.snp.trailing).inset(Size.leadingTrailingPadding + 8)
                $0.width.equalTo(270)
                $0.height.equalTo(90)
            }
        }
        
        self.guideBoxImageView.addSubview(self.guideLabel)
        self.guideLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
    }

    // MARK: - func

    private func configureDelegation() {
        self.letterView.configureDelegation(self)
    }

    private func hideGuideViewWhenTappedAround() {
        let navigationTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissGuideView))
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissGuideView))
        navigationTap.cancelsTouchesInView = false
        viewTap.cancelsTouchesInView = false
        self.navigationController?.view.addGestureRecognizer(navigationTap)
        self.view.addGestureRecognizer(viewTap)
    }

    // MARK: - selector

    @objc
    private func dismissGuideView() {
        if !self.guideButton.isTouchInside {
            self.guideBoxImageView.isHidden = true
        }
    }

    // MARK: - network
    
    private func fetchSendLetter(roomId: String) {
        Task {
            do {
                let letterContent = try await self.letterSevice.fetchSendLetter(roomId: roomId)
                
                if let content = letterContent {
                    dump(content)
                    self.manitteeId = content.manittee?.id
                    self.letterList = content.messages
                }
            } catch NetworkError.serverError {
                print("serverError")
            } catch NetworkError.clientError(let message) {
                print("clientError:\(String(describing: message))")
            }
        }
    }
    
    private func fetchReceviedLetter(roomId: String) {
        Task {
            do {
                let letterContent = try await self.letterSevice.fetchReceiveLetter(roomId: roomId)
                
                if let content = letterContent {
                    dump(content)
                    self.letterList = content.messages
                }
            } catch NetworkError.serverError {
                print("serverError")
            } catch NetworkError.clientError(let message) {
                print("clientError:\(String(describing: message))")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension LetterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.letterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LetterCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setLetterData(with: self.letterList[indexPath.item], isHidden: self.letterState.isHidden)
        cell.didTapReport = { [weak self] in
            self?.sendReportMail(userNickname: UserDefaultStorage.nickname ?? "",
                                 content: self?.letterList[indexPath.item].content ?? "글 내용 없음")
        }
        cell.didTapImage = { [weak self] _ in
            guard let imageUrl = self?.letterList[indexPath.item].imageUrl else { return }
            let viewController = LetterImageViewController(imageUrl: imageUrl)
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .crossDissolve
            self?.present(viewController, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: LetterHeaderView.className,
                                                                                   for: indexPath) as? LetterHeaderView else {
                assert(false, "do not have reusable view")
                return UICollectionReusableView()
            }
            
            headerView.setSegmentedControlIndex(self.letterState.rawValue)
            headerView.selectedSegmentIndexDidChange = { [weak self] index in
                guard let letterStatus = LetterState.init(rawValue: index) else { return }
                self?.letterState = letterStatus
            }
            
            return headerView
        default:
            assert(false, "do not use footer")
            return UICollectionReusableView()
        }
    }
}
