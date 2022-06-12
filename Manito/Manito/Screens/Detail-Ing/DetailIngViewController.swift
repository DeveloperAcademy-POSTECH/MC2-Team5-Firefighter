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
    @IBOutlet weak var manitiLabel: UILabel!
    @IBOutlet weak var listBackView: UIView!
    @IBOutlet weak var listImageView: UIView!
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
    }
}
