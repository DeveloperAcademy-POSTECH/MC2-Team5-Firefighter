//
//  LetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

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
    
    private enum InternalSize {
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - Size.leadingTrailingPadding * 2
        static let headerHeight: CGFloat = 66.0
        static let imageHeight: CGFloat = 204.0
        static let cellInset: UIEdgeInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 35.0, right: 16.0)
        static let collectionInset: UIEdgeInsets = UIEdgeInsets(top: 18.0,
                                                                left: Size.leadingTrailingPadding,
                                                                bottom: 18.0,
                                                                right: Size.leadingTrailingPadding)
    }
    
    // MARK: - ui component
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = InternalSize.collectionInset
        flowLayout.minimumLineSpacing = 33
        flowLayout.sectionHeadersPinToVisibleBounds = true
        return flowLayout
    }()
    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cell: LetterCollectionViewCell.self,
                                forCellWithReuseIdentifier: LetterCollectionViewCell.className)
        collectionView.register(LetterHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: LetterHeaderView.className)
        return collectionView
    }()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .font(.regular, ofSize: 16)
        label.text = TextLiteral.letterViewControllerEmptyViewTo
        label.isHidden = true
        label.textColor = .grey003
        label.textAlignment = .center
        label.addLabelSpacing(lineSpacing: 16)
        return label
    }()
    private lazy var sendLetterView: BottomOfSendLetterView = BottomOfSendLetterView()

    // MARK: - property
    
    private var letterState: LetterState {
        didSet {
            self.reloadCollectionView(with: self.letterState)
            self.setupEmptyLabel()
        }
    }
    private var letterList: [Message] = [] {
        didSet {
            self.listCollectionView.reloadData()
            self.setupEmptyView()
        }
    }
    private let letterSevice: LetterAPI = LetterAPI(apiService: APIService())
    private var manitteeId: String?
    private var roomId: String
    private var roomState: String
    private var mission: String
    
    // MARK: - init
    
    init(roomState: String, roomId: String, mission: String, letterState: LetterState) {
        self.roomState = roomState
        self.roomId = roomId
        self.mission = mission
        self.letterState = letterState
        super.init()
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
        self.setupButtonAction()
        self.setupGuideArea()
        self.renderGuideArea()
        self.hideGuideViewWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupLargeTitle()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.guideBoxImageView.isHidden = true
    }

    // MARK: - override
    
    override func setupLayout() {
        self.view.addSubview(self.listCollectionView)
        self.listCollectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.view.addSubview(self.guideButton)
        self.guideButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }

        self.view.addSubview(self.emptyLabel)
        self.emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        if self.roomState != "POST" {
            self.view.addSubview(self.sendLetterView)
            self.sendLetterView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
    }
    
    override func configureUI() {
        super.configureUI()
        self.reloadCollectionView(with: self.letterState)
        self.setupEmptyLabel()
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
    
    private func setupLargeTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func setupEmptyView() {
        self.emptyLabel.isHidden = !self.letterList.isEmpty
    }
    
    private func setupButtonAction() {
        let presentSendButtonAction = UIAction { [weak self] _ in
            guard let self = self,
                  let manitteeId = self.manitteeId
            else { return }
            
            let viewController = CreateLetterViewController(manitteeId: manitteeId, roomId: self.roomId, mission: self.mission)
            let navigationController = UINavigationController(rootViewController: viewController)
            viewController.createLetter = { [weak self] in
                guard let roomId = self?.roomId else { return }
                self?.fetchSendLetter(roomId: roomId)
            }
            self.present(navigationController, animated: true, completion: nil)
        }
        self.sendLetterView.addAction(presentSendButtonAction)
    }
    
    private func reloadCollectionView(with state: LetterState) {
        let isReceivedState = (state == .received)
        let bottomInset: CGFloat = (isReceivedState ? 0 : 73)
        let topPoint = self.listCollectionView.adjustedContentInset.top + 1
        
        self.sendLetterView.isHidden = isReceivedState
        self.listCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        self.listCollectionView.setContentOffset(CGPoint(x: 0, y: -topPoint), animated: false)
        self.listCollectionView.collectionViewLayout.invalidateLayout()
        
        switch state {
        case .sent:
            self.fetchSendLetter(roomId: self.roomId)
        case .received:
            self.fetchReceviedLetter(roomId: self.roomId)
        }
    }
    
    private func calculateContentHeight(text: String) -> CGFloat {
        let width = UIScreen.main.bounds.size.width - Size.leadingTrailingPadding * 2 - InternalSize.cellInset.left * 2
        let label = UILabel(frame: CGRect(origin: .zero,
                                          size: CGSize(width: width,
                                                       height: .greatestFiniteMagnitude)))
        label.text = text
        label.font = .font(.regular, ofSize: 15)
        label.numberOfLines = 0
        label.addLabelSpacing()
        label.sizeToFit()
        return label.frame.height
    }
    
    private func hideGuideViewWhenTappedAround() {
        let navigationTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissGuideView))
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissGuideView))
        navigationTap.cancelsTouchesInView = false
        viewTap.cancelsTouchesInView = false
        self.navigationController?.view.addGestureRecognizer(navigationTap)
        self.view.addGestureRecognizer(viewTap)
    }
    
    private func setupEmptyLabel() {
        self.emptyLabel.text = self.letterState.labelText
        self.emptyLabel.isHidden = true
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
        cell.didTappedReport = { [weak self] in
            self?.sendReportMail(userNickname: UserDefaultStorage.nickname ?? "",
                                 content: self?.letterList[indexPath.item].content ?? "글 내용 없음")
        }
        cell.didTappedImage = { [weak self] image in
            let viewController = LetterImageViewController(image: image)
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

// MARK: - UICollectionViewDelegateFlowLayout
extension LetterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heights = [InternalSize.cellInset.top, InternalSize.cellInset.bottom]
        
        if let content = self.letterList[indexPath.item].content {
            heights += [self.calculateContentHeight(text: content)]
        }

        if self.letterList[indexPath.item].imageUrl != nil {
            heights += [InternalSize.imageHeight]
        }
        
        return CGSize(width: InternalSize.cellWidth, height: heights.reduce(0, +))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: InternalSize.headerHeight)
    }
}

// MARK: - UICollectionViewDelegate
extension LetterViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.guideBoxImageView.isHidden = true
    }
}
