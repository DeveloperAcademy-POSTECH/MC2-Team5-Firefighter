//
//  LetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

final class LetterViewController: BaseViewController {

    enum EntryPoint: Int {
        case detail = 0, notification = 1
    }

    private enum InternalSize {
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - Size.leadingTrailingPadding * 2
        static let cellInset: UIEdgeInsets = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 22.0, right: 16.0)
        static let imageHeight: CGFloat = 204.0
    }

    // MARK: - ui component

    private let letterView: LetterView = LetterView()

    // MARK: - property

    private var letterList: [Message] = [] {
        willSet(list) {
            self.letterView.updateLetterViewEmptyState(isHidden: !list.isEmpty)
            self.letterView.reloadCollectionViewData()
        }
    }
    private let letterSevice: LetterAPI = LetterAPI(apiService: APIService())
    private var manitteeId: String?
    private var roomState: String
    private var roomId: String
    private var mission: String
    private var missionId: String
    private var entryPoint: EntryPoint
    
    // MARK: - init
    
    init(roomState: String,
         roomId: String,
         mission: String,
         missionId: String,
         entryPoint: EntryPoint) {
        self.roomState = roomState
        self.roomId = roomId
        self.mission = mission
        self.missionId = missionId
        self.entryPoint = entryPoint
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
        self.configureDelegation()
        self.configureLetterType()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.letterView.configureNavigationController(self)
    }

    // MARK: - override

    override func configureUI() {
        super.configureUI()
        // FIXME: - roomState를 Text말고 Enum으로 관리하도록 수정합니다.
        if roomState == "PROCESSING" {
            self.letterView.configureBottomArea()
        }
    }

    // MARK: - func

    private func configureDelegation() {
        self.letterView.configureDelegation(self)
    }

    private func configureLetterType() {
        let entryIndex = self.entryPoint.rawValue
        self.letterView.updateLetterType(to: .init(rawValue: entryIndex) ?? .sent)
    }

    private func handleResponse(_ response: Result<Letter, NetworkError>) {
        switch response {
        case .success(let data):
            self.manitteeId = data.manittee?.id
            self.letterList = data.messages
        case .failure:
            self.makeAlert(title: TextLiteral.letterViewControllerErrorTitle,
                           message: TextLiteral.letterViewControllerErrorDescription)
        }
    }
    
    // MARK: - network
    
    private func fetchSendLetter(roomId: String, completionHandler: @escaping ((Result<Letter, NetworkError>) -> Void)) {
        Task {
            do {
                let letterData = try await self.letterSevice.fetchSendLetter(roomId: roomId)
                if let letterData {
                    completionHandler(.success(letterData))
                } else {
                    completionHandler(.failure(.unknownError))
                }
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
            }
        }
    }
    
    private func fetchReceivedLetter(roomId: String, completionHandler: @escaping ((Result<Letter, NetworkError>) -> Void)) {
        Task {
            do {
                let letterData = try await self.letterSevice.fetchReceiveLetter(roomId: roomId)
                if let letterData {
                    completionHandler(.success(letterData))
                } else {
                    completionHandler(.failure(.unknownError))
                }
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
            }
        }
    }
}

// MARK: - LetterViewDelegate
extension LetterViewController: LetterViewDelegate {
    func presentCreateLetterViewController() {
        guard let manitteeId else { return }
        let viewController = CreateLetterViewController(manitteeId: manitteeId,
                                                        roomId: self.roomId,
                                                        mission: self.mission,
                                                        missionId: self.missionId)
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.configureDelegation(self)
        self.present(navigationController, animated: true)
    }

    func fetchSentLetter() {
        self.fetchSendLetter(roomId: self.roomId) { [weak self] response in
            self?.handleResponse(response)
        }
    }

    func fetchReceivedLetter() {
        self.fetchReceivedLetter(roomId: self.roomId) { [weak self] response in
            self?.handleResponse(response)
        }
    }
}

// MARK: - CreateLetterViewControllerDelegate
extension LetterViewController: CreateLetterViewControllerDelegate {
    func refreshLetterData() {
        self.letterView.updateLetterType(to: .sent)
    }
}

// MARK: - LetterCollectionViewCellDelegate
extension LetterViewController: LetterCollectionViewCellDelegate {
    func didTapReportButton(content: String) {
        self.sendReportMail(userNickname: UserDefaultStorage.nickname ?? "", content: content)
    }

    func didTapLetterImageView(imageURL: String) {
        let viewController = LetterImageViewController(imageUrl: imageURL)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
}

// MARK: - LetterHeaderViewDelegate
extension LetterViewController: LetterHeaderViewDelegate {
    func selectedSegmentIndexDidChange(index: Int) {
        self.letterView.updateLetterType(to: .init(rawValue: index) ?? .sent)
    }
}

// MARK: - UICollectionViewDataSource
extension LetterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.letterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LetterCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let data = self.letterList[indexPath.item]
        let canReport = self.letterView.letterType == .received
        cell.configureCell((mission: data.mission,
                            date: data.date,
                            content: data.content,
                            imageURL: data.imageUrl,
                            isTodayLetter: data.isToday,
                            canReport: canReport))
        cell.configureDelegation(self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LetterHeaderView.className,
                for: indexPath
            ) as? LetterHeaderView else { return UICollectionReusableView() }
            headerView.configureDelegation(self)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LetterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heights = [InternalSize.cellInset.top, InternalSize.cellInset.bottom]

        if let content = self.letterList[indexPath.item].content {
            heights += [self.calculateCellContentViewHeight(by: content)]
        }

        if let mission = self.letterList[indexPath.item].mission {
            heights += [self.calculateCellContentViewHeight(by: mission) + 10]
        } else {
            let date = self.letterList[indexPath.item].date
            heights += [self.calculateCellContentViewHeight(by: date) + 5]
        }

        if self.letterList[indexPath.item].imageUrl != nil {
            heights += [InternalSize.imageHeight]
        }

        return CGSize(width: InternalSize.cellWidth, height: heights.reduce(0, +))
    }

    private func calculateCellContentViewHeight(by text: String) -> CGFloat {
        let width = UIScreen.main.bounds.size.width - Size.leadingTrailingPadding * 2 - InternalSize.cellInset.left * 2
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: width, height: .greatestFiniteMagnitude)))
        label.text = text
        label.font = .font(.regular, ofSize: 15)
        label.numberOfLines = 0
        label.addLabelSpacing()
        label.sizeToFit()
        return label.frame.height
    }
}

// MARK: - UICollectionViewDelegate
extension LetterViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.letterView.scrollViewDidEndDraggingConfiguration()
    }
}
