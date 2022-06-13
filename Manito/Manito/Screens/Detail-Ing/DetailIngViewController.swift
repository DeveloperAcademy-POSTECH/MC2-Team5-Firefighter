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
    
    private let manitoOpenButton: UIButton = {
        let button = MainButton()
        button.title = "마니또 공개"
        button.hasShadow = true
        return button
    }()
    
    // MARK: - life cycle
    
    override func render() {
        view.addSubview(manitoOpenButton)
        manitoOpenButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(7)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func configUI() {
        super.configUI()
        
        setupFont()
        setupViewLayer()
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
        manitiBackView.layer.cornerRadius = 10
        manitiBackView.layer.borderWidth = 1
        manitiBackView.layer.borderColor = UIColor.white.cgColor
        manitiImageView.layer.cornerRadius = 50
        listBackView.layer.cornerRadius = 10
        listBackView.layer.borderWidth = 1
        listBackView.layer.borderColor = UIColor.white.cgColor
        listImageView.layer.cornerRadius = 50
        letterBoxButton.layer.cornerRadius = 10
        letterBoxButton.layer.borderWidth = 1
        letterBoxButton.layer.borderColor = UIColor.white.cgColor
        manitoMemoryButton.layer.cornerRadius = 10
        manitoMemoryButton.layer.borderWidth = 1
        manitoMemoryButton.layer.borderColor = UIColor.white.cgColor
    }
}
