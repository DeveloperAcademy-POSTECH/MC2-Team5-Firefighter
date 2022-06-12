//
//  DetailIngViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

class DetailIngViewController: BaseViewController {

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
    @IBOutlet weak var manitoOpenButton: UIButton!
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configUI() {
        super.configUI()
        
        titleLabel.font = .font(.regular, ofSize: 34)
        periodLabel.font = .font(.regular, ofSize: 16)
        missionTitleLabel.font = .font(.regular, ofSize: 14)
        missionContentsLabel.font = .font(.regular, ofSize: 18)
        informationTitleLabel.font = .font(.regular, ofSize: 16)
        manitiLabel.font = .font(.regular, ofSize: 15)
        listLabel.font = .font(.regular, ofSize: 15)
        letterBoxButton.titleLabel?.font = .font(.regular, ofSize: 15)
        
        missionBackgroundView.layer.cornerRadius = 10
        manitiBackView.layer.cornerRadius = 10
        manitiImageView.layer.cornerRadius = 50
        listBackView.layer.cornerRadius = 10
        listImageView.layer.cornerRadius = 50
        letterBoxButton.layer.cornerRadius = 10
    }
}
