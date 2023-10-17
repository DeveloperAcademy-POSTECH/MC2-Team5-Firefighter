//
//  MemoryView.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/16/23.
//

import Combine
import UIKit

import SnapKit

final class MemoryView: UIView, BaseViewType {
    
    typealias MemoryDetail = (announcingText: String, nickname: String, backgroundColor: UIColor, image: UIImage)
    
    private enum Size {
        static let lineSpacing: CGFloat = 10.0
        static let margin: CGFloat = 16.0
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - (margin * 2 + lineSpacing)) / 2
        static let cellHeight: CGFloat = cellWidth * 0.9
        static let collectionViewHeight: CGFloat = cellHeight * 2 + lineSpacing
    }
    
    // MARK: - ui component
    
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [TextLiteral.Letter.manitteTitle.localized(),
                                                 TextLiteral.Letter.manittoTitle.localized()])
        let font = UIFont.font(.regular, ofSize: 14)
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: font]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: font]
        
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        control.selectedSegmentTintColor = .white
        control.backgroundColor = .darkGrey004
        control.selectedSegmentIndex = 0
        
        return control
    }()
    private lazy var memoryCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        flowLayout.minimumLineSpacing = Size.lineSpacing
        flowLayout.minimumInteritemSpacing = Size.lineSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: Size.margin, bottom: 0, right: Size.margin)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(MemoryCollectionViewCell.self, forCellWithReuseIdentifier: MemoryCollectionViewCell.className)
        return collectionView
    }()
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
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.Icon.insta, for: .normal)
        return button
    }()
    private let manittoTopImageView = UIImageView(image: UIImage.Image.characters)
    private let manittoBottomImageView = UIImageView(image: UIImage.Image.characters)
    private let characterImageView = UIImageView()
    private let instaShareBoundView = UIView()
    private let characterBackView: UIView = {
        let view = UIView()
        view.makeBorderLayer(color: .white)
        view.layer.cornerRadius = 49.5
        return view
    }()
    
    // MARK: - property
    
    var segmentControlPublisher: AnyPublisher<Int, Never> {
        return self.segmentControl.tapPublisher
            .compactMap { [weak self] in self?.segmentControl.selectedSegmentIndex }
            .eraseToAnyPublisher()
    }
    var shareButtonPublisher: AnyPublisher<Data, Never> {
        return self.shareButton.tapPublisher
            .compactMap { [weak self] in
                self?.convert(self?.instaShareBoundView)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubview(self.segmentControl)
        self.segmentControl.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
            $0.width.equalTo(294)
        }
        
        self.addSubview(self.instaShareBoundView)
        self.instaShareBoundView.snp.makeConstraints {
            $0.top.equalTo(self.segmentControl.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(31)
        }
        
        self.instaShareBoundView.addSubview(self.manittoTopImageView)
        self.manittoTopImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(40)
        }
        
        self.instaShareBoundView.addSubview(self.announcementLabel)
        self.announcementLabel.snp.makeConstraints {
            $0.top.equalTo(self.manittoTopImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        self.instaShareBoundView.addSubview(self.memoryCollectionView)
        self.memoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.announcementLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Size.collectionViewHeight)
        }
        
        self.instaShareBoundView.addSubview(self.manittoBottomImageView)
        self.manittoBottomImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(40)
        }
        
        self.instaShareBoundView.addSubview(self.nicknameLabel)
        self.nicknameLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.manittoBottomImageView.snp.top).offset(-30)
            $0.centerX.equalToSuperview()
        }
        
        self.instaShareBoundView.addSubview(self.characterBackView)
        self.characterBackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.memoryCollectionView.snp.centerY)
            $0.width.height.equalTo(99)
        }
        
        self.characterBackView.addSubview(self.characterImageView)
        self.characterImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(90)
        }
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }
    
    // MARK: - func
    
    func configureDelegation(_ delegate: UICollectionViewDataSource) {
        self.memoryCollectionView.dataSource = delegate
    }
    
    func configureNavigationBar(of viewController: UIViewController) {
        guard let navigationController = viewController.navigationController else { return }
        let shareButton = UIBarButtonItem(customView: shareButton)
        navigationController.navigationItem.rightBarButtonItem = shareButton
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationItem.largeTitleDisplayMode = .automatic
        viewController.title = TextLiteral.Memory.title.localized()
    }
    
    func updateMemoryView(_ detail: MemoryDetail) {
        self.announcementLabel.text = detail.announcingText
        self.nicknameLabel.text = detail.nickname
        self.characterBackView.backgroundColor = detail.backgroundColor
        self.characterImageView.image = detail.image
        self.memoryCollectionView.reloadData()
    }
}

// MARK: - Helper
extension MemoryView {
    private func convert(_ inputView: UIView?) -> Data? {
        guard let view = inputView else { return nil }
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let renderImage = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return renderImage.pngData()
    }
}
