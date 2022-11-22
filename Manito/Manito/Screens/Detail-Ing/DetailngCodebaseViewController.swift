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
        view.makeBorderLayer(color: .systemYellow)
        return view
    }()
    private let missionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 개별 미션"
        label.textColor = .grey002
        label.font = .font(.regular, ofSize: 14)
        return label
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
        label.text = "진행 정보"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private lazy var manitteeBackView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedManittee))
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
        label.textColor = .white
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    private lazy var listBackView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushFriendListViewController(_:)))
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
    private let letterBoxButton: UIButton = {
        let button = UIButton(type: .system)
        let action = UIAction { _ in
            print("쪽지함!!")
        }
        button.addAction(action, for: .touchUpInside)
        button.setTitle("쪽지함", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 15)
        button.backgroundColor = .darkGrey002
        button.makeBorderLayer(color: .white)
        return button
    }()
    private let manitoMemoryButton: UIButton = {
        let button = UIButton(type: .system)
        let action = UIAction { _ in
            print("함께 했던 기록!!")
        }
        button.addAction(action, for: .touchUpInside)
        button.setTitle("함께 했던 기록", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 15)
        button.backgroundColor = .darkGrey002
        button.makeBorderLayer(color: .white)
        button.isHidden = true
        return button
    }()
    private let manitteeAnimationLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    private let manitiRealIconView: UIImageView = {
        let imageView = UIImageView(image: ImageLiterals.imgMa)
        imageView.alpha = 0
        return imageView
    }()
    private let manitoOpenButton: MainButton = {
        let button = MainButton()
        let action = UIAction { _ in
            print("마니또 공개!!")
        }
        button.addAction(action, for: .touchUpInside)
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
            $0.centerY.equalTo(missionTitleLabel.snp.bottom).offset(30)
            $0.centerX.equalTo(missionBackgroundView.snp.centerX)
            $0.leading.trailing.equalTo(missionBackgroundView).inset(12)
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
            $0.trailing.equalTo(view.snp.centerX).offset(-14)
            $0.height.equalTo((UIScreen.main.bounds.width-28-40)/2)
        }
        
        manitteeBackView.addSubview(manitteeImageView)
        manitteeImageView.snp.makeConstraints {
            $0.top.equalTo(manitteeBackView.snp.top).inset(16)
            $0.centerX.equalTo(manitteeBackView)
            $0.width.height.equalTo(99)
        }
        
        manitteeBackView.addSubview(manitteeIconView)
        manitteeIconView.snp.makeConstraints {
            $0.centerX.equalTo(manitteeImageView)
            $0.centerY.equalTo(manitteeImageView.snp.centerY)
            $0.width.height.equalTo(90)
        }
        
        manitteeBackView.addSubview(manitteeLabel)
        manitteeLabel.snp.makeConstraints {
            $0.bottom.equalTo(manitteeBackView.snp.bottom).inset(15)
            $0.centerX.equalTo(manitteeBackView)
        }
        
        view.addSubview(listBackView)
        listBackView.snp.makeConstraints {
            $0.top.equalTo(informationTitleLabel.snp.bottom).offset(31)
            $0.leading.equalTo(view.snp.centerX).offset(14)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.height.equalTo((UIScreen.main.bounds.width-28-40)/2)
        }
        
        listBackView.addSubview(listImageView)
        listImageView.snp.makeConstraints {
            $0.top.equalTo(listBackView.snp.top).inset(16)
            $0.centerX.equalTo(listBackView)
            $0.width.height.equalTo(99)
        }

        listBackView.addSubview(listIconView)
        listIconView.snp.makeConstraints {
            $0.centerX.equalTo(listImageView)
            $0.centerY.equalTo(listImageView.snp.centerY)
            $0.width.height.equalTo(80)
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
        setupText()
    }
    
    override func setupGuideArea() {
        super.setupGuideArea()
        guideButton.setImage(ImageLiterals.icMissionInfo, for: .normal)
        setupGuideText(title: TextLiteral.detailIngViewControllerGuideTitle, text: TextLiteral.detailIngViewControllerText)
    }

    private func setupText() {
        titleLabel.text = "애니또 팀"
        periodLabel.text = "22.11.11 ~ 22.11.15"
        statusLabel.text = "진행중"
        missionContentsLabel.attributedText = NSAttributedString(string: "1000원 이하의 선물 주고 인증샷 받기")
        manitteeLabel.text = "디너의 마니띠"
        manitteeAnimationLabel.text = "호야"
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

