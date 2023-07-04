//
//  DetailingView.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/06/19.
//

import UIKit

import SnapKit

protocol DetailingDelegate: AnyObject {
    func editMissionButtonDidTap(mission: String)
    func listBackDidTap()
    func letterBoxDidTap(type: String,
                         mission: String,
                         missionId: String)
    func manittoMemoryButtonDidTap()
    func manittoOpenButtonDidTap(nickname: String)
    func deleteButtonDidTap()
    func leaveButtonDidTap()
    func didNotShowManitteeView(manitteeName: String)
}

final class DetailingView: UIView {
    
    enum RoomType: String {
        case PROCESSING
        case POST
    }
    
    // MARK: - property
    
    private var isTappedManittee: Bool = false
    private var missionId: String = ""
    private var manittoNickname: String = ""
    // FIXME: - roomType 상태를 View에서 가지고 있으면 안될 거 같습니다. 나중에 리팩토링하실 때 이 부분 신경써주세요!
    var roomType: RoomType = .PROCESSING
    private weak var delegate: DetailingDelegate?
    
    // MARK: - component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey002
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11
        label.textColor = .white
        label.font = .font(.regular, ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    private let missionBackgroundView: UIView = {
        var view = UIView()
        view.backgroundColor = .darkGrey004
        return view
    }()
    private let missionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.individualMissionViewTitleLabel
        label.textColor = .grey002
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    private lazy var pencilButton: UIButton = {
        let button = UIButton(type: .system)
        let action = UIAction { [weak self] _ in
            guard let mission = self?.missionContentsLabel.text else { return }
            self?.delegate?.editMissionButtonDidTap(mission: mission)
        }
        button.addAction(action, for: .touchUpInside)
        button.setImage(ImageLiterals.icPencil, for: .normal)
        return button
    }()
    private let missionContentsLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        let attributedText = NSAttributedString(string: "", attributes: [.paragraphStyle: paragraphStyle])
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    private let informationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.detailIngViewControllerDetailInformatioin
        label.textColor = .white
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private lazy var manitteeBackView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTappedManittee))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .darkGrey002
        view.makeBorderLayer(color: .white)
        return view
    }()
    private let manitteeImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .subOrange
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey005.cgColor
        view.layer.cornerRadius = 49.5
        return view
    }()
    private let manitteeIconView = UIImageView(image: ImageLiterals.icManiTti)
    private let manitteeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(UserDefaultStorage.nickname)의 마니띠"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    private lazy var listBackView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTappedListBack))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .darkGrey002
        view.makeBorderLayer(color: .white)
        return view
    }()
    private let listImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .subPink
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey005.cgColor
        view.layer.cornerRadius = 49.5
        return view
    }()
    private let listIconView = UIImageView(image: ImageLiterals.icList)
    private let listLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.togetherFriend
        label.textColor = .white
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    private lazy var letterBoxButton: UIButton = {
        let button = UIButton(type: .system)
        let action = UIAction { [weak self] _ in
            guard let roomType = self?.roomType,
                  let mission = self?.missionContentsLabel.text
            else { return }
            self?.delegate?.letterBoxDidTap(type: roomType.rawValue,
                                            mission: mission,
                                            missionId: self?.missionId ?? "")
        }
        button.addAction(action, for: .touchUpInside)
        button.setTitle(TextLiteral.letterViewControllerTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 15)
        button.backgroundColor = .darkGrey002
        button.makeBorderLayer(color: .white)
        return button
    }()
    private lazy var manittoMemoryButton: UIButton = {
        let button = UIButton(type: .system)
        let action = UIAction { [weak self] _ in
            self?.delegate?.manittoMemoryButtonDidTap()
        }
        button.addAction(action, for: .touchUpInside)
        button.setTitle(TextLiteral.memoryViewControllerTitleLabel, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 15)
        button.backgroundColor = .darkGrey002
        button.makeBorderLayer(color: .white)
        return button
    }()
    private let manitteeAnimationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.alpha = 0
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    private let manitiRealIconView: UIImageView = {
        let imageView = UIImageView(image: ImageLiterals.imgMa)
        imageView.alpha = 0
        return imageView
    }()
    private let manittoOpenButtonShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainRed
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 30
        view.makeShadow(color: .shadowRed, opacity: 1.0, offset: CGSize(width: 0, height: 6), radius: 1)
        view.isHidden = true
        return view
    }()
    // FIXME: - 마니또 공개 API 확실히 하기
    private lazy var manittoOpenButton: MainButton = {
        let button = MainButton()
        let action = UIAction { [weak self] _ in
            guard let manittoNickname = self?.manittoNickname else { return }
            self?.delegate?.manittoOpenButtonDidTap(nickname: manittoNickname)
        }
        button.addAction(action, for: .touchUpInside)
        button.title = TextLiteral.detailIngViewControllerManitoOpenButton
        return button
    }()
    private let badgeLabel: LetterCountBadgeView = {
        let label = LetterCountBadgeView()
        label.layer.cornerRadius = 15
        label.isHidden = true
        return label
    }()
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.icMore, for: .normal)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    private let guideView: GuideView = GuideView(type: .detailing)
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.addSubview(self.periodLabel)
        self.periodLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        
        self.addSubview(self.statusLabel)
        self.statusLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.titleLabel.snp.centerY)
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(6)
            $0.width.equalTo(67)
            $0.height.equalTo(23)
        }

        self.addSubview(self.missionBackgroundView)
        self.missionBackgroundView.snp.makeConstraints {
            $0.top.equalTo(self.periodLabel.snp.bottom).offset(31)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(100)
        }
        
        self.missionBackgroundView.addSubview(self.missionTitleLabel)
        self.missionTitleLabel.snp.makeConstraints{
            $0.top.equalTo(self.missionBackgroundView.snp.top).inset(12)
            $0.centerX.equalTo(self.missionBackgroundView.snp.centerX)
        }
        
        self.missionBackgroundView.addSubview(self.missionContentsLabel)
        self.missionContentsLabel.snp.makeConstraints{
            $0.centerY.equalTo(self.missionTitleLabel.snp.bottom).offset(30)
            $0.centerX.equalTo(self.missionBackgroundView.snp.centerX)
            $0.leading.trailing.equalTo(self.missionBackgroundView).inset(12)
        }

        self.addSubview(self.informationTitleLabel)
        self.informationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.missionBackgroundView.snp.bottom).offset(44)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.addSubview(self.manitteeBackView)
        self.manitteeBackView.snp.makeConstraints {
            $0.top.equalTo(self.informationTitleLabel.snp.bottom).offset(31)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.trailing.equalTo(self.snp.centerX).offset(-14)
            $0.height.equalTo((UIScreen.main.bounds.width - 28 - 40) / 2)
        }
        
        self.manitteeBackView.addSubview(self.manitteeImageView)
        self.manitteeImageView.snp.makeConstraints {
            $0.top.equalTo(self.manitteeBackView.snp.top).inset(16)
            $0.centerX.equalTo(self.manitteeBackView)
            $0.width.height.equalTo(99)
        }
        
        self.manitteeBackView.addSubview(self.manitteeIconView)
        self.manitteeIconView.snp.makeConstraints {
            $0.centerX.equalTo(self.manitteeImageView)
            $0.centerY.equalTo(self.manitteeImageView.snp.centerY)
            $0.width.height.equalTo(90)
        }
        
        self.manitteeBackView.addSubview(self.manitteeLabel)
        self.manitteeLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.manitteeBackView.snp.bottom).inset(15)
            $0.centerX.equalTo(self.manitteeBackView)
        }
        
        self.manitteeBackView.addSubview(self.manitteeAnimationLabel)
        self.manitteeAnimationLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.manitteeBackView.snp.bottom).inset(15)
            $0.centerX.equalTo(self.manitteeBackView)
        }
        
        self.addSubview(self.listBackView)
        self.listBackView.snp.makeConstraints {
            $0.top.equalTo(self.informationTitleLabel.snp.bottom).offset(31)
            $0.leading.equalTo(self.snp.centerX).offset(14)
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo((UIScreen.main.bounds.width - 28 - 40) / 2)
        }
        
        self.listBackView.addSubview(self.listImageView)
        self.listImageView.snp.makeConstraints {
            $0.top.equalTo(self.listBackView.snp.top).inset(16)
            $0.centerX.equalTo(self.listBackView)
            $0.width.height.equalTo(99)
        }

        self.listBackView.addSubview(self.listIconView)
        self.listIconView.snp.makeConstraints {
            $0.centerX.equalTo(self.listImageView)
            $0.centerY.equalTo(self.listImageView.snp.centerY)
            $0.width.height.equalTo(80)
        }
        
        self.listBackView.addSubview(self.listLabel)
        self.listLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.listBackView.snp.bottom).inset(15)
            $0.centerX.equalTo(self.listBackView)
        }
        
        self.addSubview(self.letterBoxButton)
        self.letterBoxButton.snp.makeConstraints {
            $0.top.equalTo(self.manitteeBackView.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(80)
        }
        
        self.addSubview(self.manittoMemoryButton)
        self.manittoMemoryButton.snp.makeConstraints {
            $0.top.equalTo(self.letterBoxButton.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(80)
        }
        
        self.addSubview(self.manittoOpenButtonShadowView)
        self.manittoOpenButtonShadowView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(60)
        }
        
        self.manittoOpenButtonShadowView.addSubview(self.manittoOpenButton)
        self.manittoOpenButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(self.manitiRealIconView)
        self.manitiRealIconView.snp.makeConstraints {
            $0.top.equalTo(self.manitteeIconView.snp.top)
            $0.trailing.equalTo(self.manitteeIconView.snp.trailing)
            $0.leading.equalTo(self.manitteeIconView.snp.leading)
            $0.bottom.equalTo(self.manitteeIconView.snp.bottom)
        }

        self.addSubview(self.badgeLabel)
        self.badgeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(35)
            $0.centerY.equalTo(letterBoxButton).offset(-10)
            $0.width.height.equalTo(30)
        }

        self.addSubview(self.guideView)
        self.guideView.snp.makeConstraints {
            $0.top.equalTo(self.missionBackgroundView.snp.top)
            $0.trailing.equalTo(self.missionBackgroundView.snp.trailing)
        }
        self.guideView.setupGuideViewLayout()
        
        self.addSubview(self.pencilButton)
        self.pencilButton.snp.makeConstraints {
            $0.leading.equalTo(self.missionTitleLabel.snp.trailing).offset(-6)
            $0.centerY.equalTo(self.missionTitleLabel.snp.centerY)
            $0.width.height.equalTo(44)
        }
    }
    
    func configureDelegation(_ delegate: DetailingDelegate) {
        self.delegate = delegate
    }
    
    func configureNavigationItem(_ navigationController: UINavigationController) {
        let navigationItem = navigationController.topViewController?.navigationItem
        let exitButton = UIBarButtonItem(customView: self.exitButton)
        
        navigationItem?.rightBarButtonItem = exitButton
    }
    
    func updateDetailingView(room: Room) {
        guard let state = room.roomInformation?.state,
              let title = room.roomInformation?.title,
              let startDate = room.roomInformation?.startDate,
              let endDate = room.roomInformation?.endDate,
              let manittee = room.manittee?.nickname,
              let admin = room.admin,
              let badgeCount = room.messages?.count
        else { return }
        self.roomType = RoomType.init(rawValue: state) ?? .PROCESSING
        self.missionId = room.mission?.id?.description ?? ""
        DispatchQueue.main.async {
            self.titleLabel.text = title
            self.periodLabel.text = "\(startDate.subStringToDate()) ~ \(endDate.subStringToDate())"
            self.manitteeAnimationLabel.text = manittee
            self.setupBadge(count: badgeCount)
            self.updateMissionEditButton(admin, type: self.roomType)
            if self.roomType == .PROCESSING {
                self.setupProcessingUI()
                guard let missionContent = room.mission?.content,
                      let didView = room.didViewRoulette,
                      let manittoNickname = room.manitto?.nickname
                else { return }
                self.missionContentsLabel.attributedText = NSAttributedString(string: missionContent)
                self.manittoNickname = manittoNickname
                if !didView && !admin {
                    self.delegate?.didNotShowManitteeView(manitteeName: manittee)
                }
                self.setupManittoOpenButton(date: endDate)
            } else {
                self.setupPostUI()
                self.setupExitButton(admin: admin)
            }
        }
    }
    
    func updateMission(mission: String) {
        self.missionContentsLabel.text = mission
    }
    
    private func setupExitButton(admin: Bool) {
        if admin {
            let menu = UIMenu(options: [], children: [
                UIAction(title: TextLiteral.detailWaitViewControllerDeleteRoom, handler: { [weak self] _ in
                    self?.delegate?.deleteButtonDidTap()
                })
            ])
            self.exitButton.menu = menu
        } else {
            let menu = UIMenu(options: [], children: [
                UIAction(title: TextLiteral.detailWaitViewControllerLeaveRoom, handler: { [weak self] _ in
                    self?.delegate?.leaveButtonDidTap()
                })
            ])
            self.exitButton.menu = menu
        }
    }
    
    private func setupBadge(count: Int) {
        if count > 0 {
            self.badgeLabel.isHidden = false
            self.badgeLabel.countLabel.text = String(count)
        } else {
            self.badgeLabel.isHidden = true
        }
    }
    
    private func setupProcessingUI() {
        self.missionBackgroundView.makeBorderLayer(color: .subOrange)
        self.statusLabel.text = TextLiteral.doing
        self.statusLabel.backgroundColor = .mainRed
        self.manittoMemoryButton.isHidden = true
        self.exitButton.isHidden = true
    }
    
    private func setupPostUI() {
        self.missionBackgroundView.makeBorderLayer(color: .darkGrey001)
        self.statusLabel.text = TextLiteral.done
        self.statusLabel.backgroundColor = .grey002
        self.manittoMemoryButton.isHidden = false
        self.exitButton.isHidden = false
        self.missionContentsLabel.attributedText = NSAttributedString(string: TextLiteral.detailIngViewControllerDoneMissionText)
    }
    
    private func setupManittoOpenButton(date: String) {
        guard let endDate = date.stringToDateYYYY() else { return }
        self.manittoOpenButtonShadowView.isHidden = !(endDate.isOpenManitto)
    }
    
    private func toggledManitteeAnimation(_ value: Bool) {
        self.manitteeLabel.alpha = value ? 0 : 1
        self.manitteeIconView.alpha = value ? 0 : 1
        self.manitiRealIconView.alpha = value ? 1 : 0
        self.manitteeAnimationLabel.alpha = value ? 1 : 0
    }
    
    private func updateMissionEditButton(_ isAdmin: Bool, type: RoomType) {
        if type == .POST {
            self.pencilButton.isHidden = true
        }
        if !isAdmin {
            self.pencilButton.isHidden = true
        }
    }
    
    // MARK: - selector
    
    @objc
    private func didTappedListBack() {
        self.delegate?.listBackDidTap()
    }
    
    @objc
    private func didTappedManittee() {
        if !isTappedManittee {
            self.isTappedManittee = true
            UIView.animate(withDuration: 1.0) {
                self.toggledManitteeAnimation(self.isTappedManittee)
            } completion: { _ in
                UIView.animate(withDuration: 1.0, delay: 0.5) {
                    self.toggledManitteeAnimation(!self.isTappedManittee)
                } completion: { _ in
                    self.isTappedManittee = false
                }
            }
        }
    }
}
