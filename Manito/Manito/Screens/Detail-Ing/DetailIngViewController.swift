//
//  DetailIngViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class DetailIngViewController: BaseViewController {

    var isDone = false

    // MARK: - property

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var missionBackgroundView: UIView!
    @IBOutlet weak var missionTitleLabel: UILabel!
    @IBOutlet weak var missionContentsLabel: UILabel!
    @IBOutlet weak var informationTitleLabel: UILabel!
    @IBOutlet weak var manitiBackView: UIView!
    @IBOutlet weak var manitiImageView: UIView!
    @IBOutlet weak var manitiIconView: UIImageView!
    @IBOutlet weak var manitiLabel: UILabel!
    @IBOutlet weak var listBackView: UIView!
    @IBOutlet weak var listImageView: UIView!
    @IBOutlet weak var listIconView: UIImageView!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var letterBoxButton: UIButton!
    @IBOutlet weak var manitoMemoryButton: UIButton!

    private lazy var manitiRealIconView: UIImageView = {
        let imageView = UIImageView(image: ImageLiterals.imgMa)
        imageView.alpha = 0
        return imageView
    }()
    
    private let manitoOpenButton: UIButton = {
        let button = MainButton()
        button.title = "마니또 공개"
        button.hasShadow = true
        return button
    }()

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGuideArea()
        renderGuideArea()
    }

    override func render() {
        view.addSubview(manitoOpenButton)
        manitoOpenButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(7)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(manitiRealIconView)
        manitiRealIconView.snp.makeConstraints {
            $0.top.equalTo(manitiIconView.snp.top)
            $0.trailing.equalTo(manitiIconView.snp.trailing)
            $0.leading.equalTo(manitiIconView.snp.leading)
            $0.bottom.equalTo(manitiIconView.snp.bottom)
        }
        
        view.addSubview(guideButton)
        guideButton.snp.makeConstraints {
            $0.top.equalTo(missionBackgroundView.snp.top)
            $0.trailing.equalTo(missionBackgroundView.snp.trailing)
            $0.width.height.equalTo(44)
        }
    }

    override func configUI() {
        super.configUI()
        setupFont()
        setupViewLayer()
        addActionMemoryViewController()
        addActionPushLetterViewController()
        addGestureMemberList()
        addGestureManito()
        addActionOpenManittoViewController()
        
        manitiIconView.image = ImageLiterals.icManiTti
        listIconView.image = ImageLiterals.icList
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func setupGuideArea() {
        super.setupGuideArea()
        guideButton.setImage(ImageLiterals.icMissionInfo, for: .normal)
        setupGuideText(title: "개별 미션이란?", text: "개별 미션이란?\n나의 마니띠에게 전하는\n둘만의 미션을 확인할 수 있어요!")
    }

    private func setupFont() {
        titleLabel.font = .font(.regular, ofSize: 34)
        periodLabel.font = .font(.regular, ofSize: 16)
        missionTitleLabel.font = .font(.regular, ofSize: 14)
        missionContentsLabel.font = .font(.regular, ofSize: 18)
        informationTitleLabel.font = .font(.regular, ofSize: 16)
        manitiLabel.font = .font(.regular, ofSize: 15)
        listLabel.font = .font(.regular, ofSize: 15)
        letterBoxButton.titleLabel?.font = .font(.regular, ofSize: 15)
        manitoMemoryButton.titleLabel?.font = .font(.regular, ofSize: 15)
    }

    private func setupViewLayer() {
        missionBackgroundView.layer.cornerRadius = 10
        missionBackgroundView.layer.borderWidth = 1
        if isDone {
            missionBackgroundView.layer.borderColor = UIColor.white.cgColor
            manitoMemoryButton.layer.isHidden = false
            manitoOpenButton.layer.isHidden = true
        }
        else {
            missionBackgroundView.layer.borderColor = UIColor.systemYellow.cgColor
            manitoMemoryButton.layer.isHidden = true
            manitoOpenButton.layer.isHidden = false
        }
        manitiBackView.makeBorderLayer(color: .white)
        manitiImageView.layer.cornerRadius = 50
        listBackView.makeBorderLayer(color: .white)
        listImageView.layer.cornerRadius = 50
        letterBoxButton.makeBorderLayer(color: .white)
        manitoMemoryButton.makeBorderLayer(color: .white)
    }
    
    private func addGestureManito() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapManito))
        manitiBackView.addGestureRecognizer(tapGesture)
    }
    
    private func addGestureMemberList() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushFriendListViewController(_:)))
        listBackView.addGestureRecognizer(tapGesture)
    }
    
    private func addActionPushLetterViewController() {
        let action = UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(LetterViewController(), animated: true)
        }
        letterBoxButton.addAction(action, for: .touchUpInside)
    }
    
    private func addActionMemoryViewController() {
        let action = UIAction { [weak self] _ in
            let storyboard = UIStoryboard(name: "DetailIng", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: MemoryViewController.className) as? MemoryViewController else { return }
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        manitoMemoryButton.addAction(action, for: .touchUpInside)
    }
    
    private func addActionOpenManittoViewController() {
        let action = UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(OpenManittoViewController(), animated: true)
        }
        self.manitoOpenButton.addAction(action, for: .touchUpInside)
    }
    
    // MARK: - selector
    
    @objc
    private func pushFriendListViewController(_ gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "DetailIng", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: FriendListViewController.className)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func didTapManito() {
        UIView.animate(withDuration: 1.0) {
            self.manitiIconView.alpha = 0
            self.manitiRealIconView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 1.0) {
                self.manitiIconView.alpha = 1
                self.manitiRealIconView.alpha = 0
            }
        }
    }
    
    @objc
    override func endEditingView() {
        if !guideButton.isTouchInside {
            guideBoxImageView.isHidden = true
        }
    }
}
