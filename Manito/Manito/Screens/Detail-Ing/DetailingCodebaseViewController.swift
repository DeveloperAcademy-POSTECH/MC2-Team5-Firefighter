//
//  DetailingCodebaseViewController.swift
//  Manito
//
//  Created by creohwan on 2022/11/03.
//

import UIKit

class DetailingCodebaseViewController: BaseViewController {
    
    var titleLabelText = "애니또 팀"
    
    // MARK: - property
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private lazy var periodLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
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
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    private let missionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 개별 미션"
        label.textColor = .white
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
        view.makeBorderLayer(color: .white)
        return view
    }()
    private let manitteeImageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = view.bounds.size.width / 2
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
        view.makeBorderLayer(color: .white)
        return view
    }()
    private let listImageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = view.bounds.size.width / 2
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
        button.titleLabel?.font = .font(.regular, ofSize: 15)
        button.makeBorderLayer(color: .white)
        return button
    }()
    private lazy var manitoMemoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("함께 했던 기록", for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 15)
        button.makeBorderLayer(color: .white)
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
        label.isHidden = true
        return label
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configUI() {
        setUpText()
        setupViewLayer()
        
        addGestureManito()
        addGestureMemberList()
        
        addActionPushLetterViewController()
        addActionMemoryViewController()
    }

    private func setUpText() {
        titleLabel.text = "애니또 팀"
        periodLabel.text = "22.11.11 ~ 22.11.15"
        statusLabel.text = "진행중"
        missionContentsLabel.text = "웃으면서 울기!"
        manitteeLabel.text = "디너의 마니띠"
        manitteeAnimationLabel.text = "호야"
    }
    
    private func setupViewLayer() {
        missionBackgroundView.layer.borderColor = UIColor.white.cgColor
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
            print("쪽지함!!")
        }
        manitoMemoryButton.addAction(action, for: .touchUpInside)
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
