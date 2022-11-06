//
//  DetailngCodebaseViewController.swift
//  Manito
//
//  Created by creohwan on 2022/11/03.
//

import UIKit

import SnapKit

// FIXME: 스토리보드 삭제 후 클래스명 변경 요
final class DetailingCodebaseViewController: BaseViewController {

    // MARK: - property
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private lazy var periodLabel: UILabel = {
        var label = UILabel()
        label.textColor = .grey002
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private lazy var statusLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .mainRed
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11
        label.textColor = .white
        label.font = .font(.regular, ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    private var missionBackgroundView: UIView = {
        var view = UIView()
        view.backgroundColor = .darkGrey004
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.systemYellow.cgColor
        return view
    }()
    private let missionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 개별 미션"
        label.textColor = .grey002
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    private lazy var missionContentsLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    private let informationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "진행 정보"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private let manitteeBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGrey002
        view.makeBorderLayer(color: .white)
        return view
    }()
    private let manitteeImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .characterYellow
        view.layer.cornerRadius = 49.5
        return view
    }()
    private var manitteeIconView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = ImageLiterals.icManiTti
        return imageView
    }()
    private lazy var manitteeLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    private let listBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGrey002
        view.makeBorderLayer(color: .white)
        return view
    }()
    private let listImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .characterPink
        view.layer.cornerRadius = 49.5
        return view
    }()
    private let listIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.icList
        return imageView
    }()
    private let listLabel: UILabel = {
        let label = UILabel()
        label.text = "함께하는 친구들"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    private lazy var letterBoxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("쪽지함", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 15)
        button.backgroundColor = .darkGrey002
        button.makeBorderLayer(color: .white)
        return button
    }()
    private lazy var manitoMemoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("함께 했던 기록", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 15)
        button.backgroundColor = .darkGrey002
        button.makeBorderLayer(color: .white)
        button.isHidden = true
        return button
    }()
    private lazy var manitteeAnimationLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    private lazy var manitiRealIconView: UIImageView = {
        let imageView = UIImageView(image: ImageLiterals.imgMa)
        imageView.alpha = 0
        return imageView
    }()
    private let manitoOpenButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.detailIngViewControllerManitoOpenButton
        return button
    }()
    private let badgeLabel: LetterCountBadgeView = {
        let label = LetterCountBadgeView()
        label.layer.cornerRadius = 15
        label.isHidden = false
        return label
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGuideArea()
        renderGuideArea()
    }
    
    override func render() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(19)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(periodLabel)
        periodLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(6)
            $0.width.equalTo(67)
            $0.height.equalTo(23)
        }

        view.addSubview(missionBackgroundView)
        missionBackgroundView.snp.makeConstraints {
            $0.top.equalTo(periodLabel.snp.bottom).offset(31)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.height.equalTo(100)
        }
        
        missionBackgroundView.addSubview(missionTitleLabel)
        missionTitleLabel.snp.makeConstraints{
            $0.top.equalTo(missionBackgroundView.snp.top).inset(12)
            $0.centerX.equalTo(missionBackgroundView.snp.centerX)
        }
        
        missionBackgroundView.addSubview(missionContentsLabel)
        missionContentsLabel.snp.makeConstraints{
            $0.top.equalTo(missionTitleLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(missionBackgroundView.snp.centerX)
        }

        view.addSubview(informationTitleLabel)
        informationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(missionBackgroundView.snp.bottom).offset(44)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(manitteeBackView)
        manitteeBackView.snp.makeConstraints {
            $0.top.equalTo(informationTitleLabel.snp.bottom).offset(31)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.width.height.equalTo(160)
        }
        
        manitteeBackView.addSubview(manitteeImageView)
        manitteeImageView.snp.makeConstraints {
            $0.top.equalTo(manitteeBackView.snp.top).inset(16)
            $0.centerX.equalTo(manitteeBackView)
            $0.width.height.equalTo(99)
        }
        
        manitteeBackView.addSubview(manitteeIconView)
        manitteeIconView.snp.makeConstraints {
            $0.top.equalTo(manitteeBackView.snp.top).inset(16)
            $0.centerX.equalTo(manitteeBackView)
            $0.width.height.equalTo(99)
        }
        
        manitteeBackView.addSubview(manitteeLabel)
        manitteeLabel.snp.makeConstraints {
            $0.bottom.equalTo(manitteeBackView.snp.bottom).inset(15)
            $0.centerX.equalTo(manitteeBackView)
        }
        
        view.addSubview(listBackView)
        listBackView.snp.makeConstraints {
            $0.top.equalTo(informationTitleLabel.snp.bottom).offset(31)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.width.height.equalTo(160)
        }
        
        listBackView.addSubview(listImageView)
        listImageView.snp.makeConstraints {
            $0.top.equalTo(listBackView.snp.top).inset(16)
            $0.centerX.equalTo(listBackView)
            $0.width.height.equalTo(99)
        }

        listBackView.addSubview(listIconView)
        listIconView.snp.makeConstraints {
            $0.top.equalTo(listBackView.snp.top).inset(16)
            $0.centerX.equalTo(listBackView)
            $0.width.height.equalTo(99)
        }
        
        listBackView.addSubview(listLabel)
        listLabel.snp.makeConstraints {
            $0.bottom.equalTo(listBackView.snp.bottom).inset(15)
            $0.centerX.equalTo(listBackView)
        }
        
        view.addSubview(letterBoxButton)
        letterBoxButton.snp.makeConstraints {
            $0.top.equalTo(manitteeBackView.snp.bottom).offset(25)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.height.equalTo(80)
        }
        
        view.addSubview(manitoMemoryButton)
        manitoMemoryButton.snp.makeConstraints {
            $0.top.equalTo(letterBoxButton.snp.bottom).offset(18)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.height.equalTo(80)
        }
        
        view.addSubview(manitoOpenButton)
        manitoOpenButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(7)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(66)
        }

        view.addSubview(manitiRealIconView)
        manitiRealIconView.snp.makeConstraints {
            $0.top.equalTo(manitteeIconView.snp.top)
            $0.trailing.equalTo(manitteeIconView.snp.trailing)
            $0.leading.equalTo(manitteeIconView.snp.leading)
            $0.bottom.equalTo(manitteeIconView.snp.bottom)
        }

        view.addSubview(guideButton)
        guideButton.snp.makeConstraints {
            $0.top.equalTo(missionBackgroundView.snp.top)
            $0.trailing.equalTo(missionBackgroundView.snp.trailing)
            $0.width.height.equalTo(44)
        }

        view.addSubview(badgeLabel)
        badgeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(35)
            $0.centerY.equalTo(letterBoxButton).offset(-10)
            $0.width.height.equalTo(30)
        }
    }
    
    override func configUI() {
        super.configUI()
        setUpText()
        
        addGestureManito()
        addGestureMemberList()
        
        addActionPushLetterViewController()
        addActionMemoryViewController()
        addActionOpenManittoViewController()
    }
    
    override func setupGuideArea() {
        super.setupGuideArea()
        guideButton.setImage(ImageLiterals.icMissionInfo, for: .normal)
        setupGuideText(title: TextLiteral.detailIngViewControllerGuideTitle, text: TextLiteral.detailIngViewControllerText)
    }

    private func setUpText() {
        titleLabel.text = "애니또 팀"
        periodLabel.text = "22.11.11 ~ 22.11.15"
        statusLabel.text = "진행중"
        missionContentsLabel.text = "웃으면서 울기!"
        manitteeLabel.text = "디너의 마니띠"
        manitteeAnimationLabel.text = "호야"
    }

    private func addGestureManito() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedManittee))
        manitteeBackView.addGestureRecognizer(tapGesture)
    }
    
    private func addGestureMemberList() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushFriendListViewController(_:)))
        listBackView.addGestureRecognizer(tapGesture)
    }
    
    private func addActionPushLetterViewController() {
        let action = UIAction { [weak self] _ in
            print("쪽지함!!")
        }
        letterBoxButton.addAction(action, for: .touchUpInside)
    }
    
    private func addActionMemoryViewController() {
        let action = UIAction { [weak self] _ in
            print("함께 했던 기록!!")
        }
        manitoMemoryButton.addAction(action, for: .touchUpInside)
    }
    
    private func addActionOpenManittoViewController() {
        let action = UIAction { [weak self] _ in
            print("마니또 공개!!")
        }
        self.manitoOpenButton.addAction(action, for: .touchUpInside)
    }
    
    @objc
    private func didTappedManittee() {
        print("당신의 마니띠는 !!!")
    }
    
    @objc
    private func pushFriendListViewController(_ gesture: UITapGestureRecognizer) {
        print("당신의 친구들은 !!!")
    }
}

