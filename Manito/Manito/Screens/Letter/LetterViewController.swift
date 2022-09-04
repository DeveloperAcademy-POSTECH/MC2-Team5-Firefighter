//
//  LetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

final class LetterViewController: BaseViewController {
    
    private enum LetterState: Int {
        case sent = 0
        case received = 1
        
        var lists: [Letter] {
            switch self {
            case .received:
                return []
            case .sent:
                return []
            }
        }
    }
    
    private enum Size {
        static let headerHeight: CGFloat = 66.0
        static let collectionHorizontalSpacing: CGFloat = 20.0
        static let collectionVerticalSpacing: CGFloat = 18.0
        static let cellTopSpacing: CGFloat = 16.0
        static let cellBottomSpacing: CGFloat = 35.0
        static let cellHorizontalSpacing: CGFloat = 16.0
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2
        static let imageHeight: CGFloat = 204.0
        static let collectionInset = UIEdgeInsets(top: collectionVerticalSpacing,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    // MARK: - property
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = Size.collectionInset
        flowLayout.minimumLineSpacing = 33
        flowLayout.sectionHeadersPinToVisibleBounds = true
        return flowLayout
    }()
    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
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
    private let sendLetterView = SendLetterView()
    
    private var letterState: LetterState = .sent {
        didSet {
            reloadCollectionView(with: self.letterState)
        }
    }
    
    private let letterSevice: LetterAPI = LetterAPI(apiService: APIService(),
                                                    environment: .development)
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonAction()
        setupGuideArea()
        renderGuideArea()
        hideGuideViewWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSendLetter(roomId: "1")
        fetchReceviedLetter(roomId: "1")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func render() {
        view.addSubview(listCollectionView)
        listCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(sendLetterView)
        sendLetterView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(guideButton)
        guideButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
    }
    
    override func configUI() {
        super.configUI()
        sendLetterView.isHidden = (letterState == .received)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let guideButton = makeBarButtonItem(with: guideButton)
        
        navigationItem.rightBarButtonItem = guideButton
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        title = "쪽지함"
    }
    
    override func setupGuideArea() {
        super.setupGuideArea()
        guideButton.setImage(ImageLiterals.icLetterInfo, for: .normal)
        setupGuideText(title: "쪽지 쓰기는?", text: "쪽지 쓰기는?\n보낸 쪽지함에서 쓰기가 가능해요!\n받은 쪽지함은 확인만 할 수 있어요.")
    }
    
    override func renderGuideArea() {
        if let view = navigationController?.view {
            view.addSubview(guideBoxImageView)
            guideBoxImageView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(35)
                $0.trailing.equalTo(view.snp.trailing).inset(Size.collectionHorizontalSpacing + 8)
                $0.width.equalTo(270)
                $0.height.equalTo(90)
            }
        }
        
        guideBoxImageView.addSubview(guideLabel)
        guideLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    // MARK: - func
    
    private func setupButtonAction() {
        let presentSendButtonAction = UIAction { [weak self] _ in
            let storyboard = UIStoryboard(name: "Letter", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "CreateLetterNavigationController")
            self?.present(viewController, animated: true, completion: nil)
        }
        sendLetterView.sendLetterButton.addAction(presentSendButtonAction,
                                                  for: .touchUpInside)
    }
    
    private func reloadCollectionView(with state: LetterState) {
        let isReceivedState = (state == .received)
        let bottomInset: CGFloat = (isReceivedState ? 0 : 73)
        let topPoint = listCollectionView.adjustedContentInset.top + 1
        
        sendLetterView.isHidden = isReceivedState
        listCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        listCollectionView.setContentOffset(CGPoint(x: 0, y: -topPoint), animated: false)
        listCollectionView.collectionViewLayout.invalidateLayout()
        listCollectionView.reloadData()
    }
    
    private func calculateContentHeight(text: String) -> CGFloat {
        let width = UIScreen.main.bounds.size.width - Size.collectionHorizontalSpacing * 2 - Size.cellHorizontalSpacing * 2
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
        let navigationTap = UITapGestureRecognizer(target: self, action: #selector(dismissGuideView))
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(dismissGuideView))
        navigationTap.cancelsTouchesInView = false
        viewTap.cancelsTouchesInView = false
        navigationController?.view.addGestureRecognizer(navigationTap)
        view.addGestureRecognizer(viewTap)
    }
    
    // MARK: - selector
    
    @objc
    private func dismissGuideView() {
        if !guideButton.isTouchInside {
            guideBoxImageView.isHidden = true
        }
    }
    
    // MARK: - network
    
    private func fetchSendLetter(roomId: String) {
        Task {
            do {
                let letterContent = try await letterSevice.fetchSendLetter(roomId: roomId)
                
                if let content = letterContent {
                    dump(content)
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
                let letterContent = try await letterSevice.fetchReceiveLetter(roomId: roomId)
                
                if let content = letterContent {
                    dump(content)
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
        return letterState.lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LetterCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
//        cell.setLetterData(with: letterState.lists[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LetterHeaderView.className, for: indexPath) as? LetterHeaderView else { assert(false, "do not have reusable view") }
            
            headerView.segmentControlIndex = letterState.rawValue
            headerView.changeSegmentControlIndex = { [weak self] index in
                guard let letterStatus = LetterState.init(rawValue: index) else { return }
                self?.letterState = letterStatus
            }
            
            return headerView
        default:
            assert(false, "do not use footer")
        }
    }
}

// MARK: - UICollectionViewDelegate
extension LetterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heights = [Size.cellTopSpacing, Size.cellBottomSpacing]
        
//        if let content = letterState.lists[indexPath.item].content {
//            heights += [calculateContentHeight(text: content)]
//        }
//
//        if letterState.lists[indexPath.item].image != nil {
//            heights += [Size.imageHeight]
//        }
        
        return CGSize(width: Size.cellWidth, height: heights.reduce(0, +))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: Size.headerHeight)
    }
}

extension LetterViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guideBoxImageView.isHidden = true
    }
}
