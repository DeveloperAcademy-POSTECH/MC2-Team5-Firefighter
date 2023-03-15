//
//  LetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

final class LetterViewController: BaseViewController {

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

    // MARK: - ui component

    private let letterView: LetterView = LetterView()

    // MARK: - property
    
    private var letterState: LetterState {
        didSet {
            self.letterView.reloadCollectionView(with: self.letterState)
            self.letterView.setupEmptyLabel(self.letterState.labelText)
            self.letterView.setupEmptyView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.letterView.setupLargeTitle(<#UINavigationController#>)
    }

    // MARK: - override
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        // guideView.configureNavigationController()
    }

    // MARK: - func

    private func configureDelegation() {
        self.letterView.configureDelegation(self)
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

// MARK: - LetterViewDelegate
extension LetterViewController: LetterViewDelegate {
    func presentCreateLetterViewController() {
        // TODO: - manitteeId 누락 에러 메시지
        guard let manitteeId else { return }
        let viewController = CreateLetterViewController(manitteeId: manitteeId,
                                                        roomId: self.roomId,
                                                        mission: self.mission,
                                                        missionId: self.missionId)
        let navigationController = UINavigationController(rootViewController: viewController)

        viewController.succeedInSendingLetter = { [weak self] in
            guard let roomId = self?.roomId else { return }
            self?.fetchSendLetter(roomId: roomId)
        }

        self.present(navigationController, animated: true, completion: nil)
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
