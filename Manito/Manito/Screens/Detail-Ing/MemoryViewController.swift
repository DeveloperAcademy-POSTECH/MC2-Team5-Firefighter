//
//  MemoryViewController.swift
//  Manito
//
//  Created by 최성희 on 2022/06/14.
//

import UIKit

class MemoryViewController: BaseViewController {
    @IBOutlet weak var memoryControl: UISegmentedControl!
    @IBOutlet weak var memoryIconView: UIImageView!
    @IBOutlet weak var memoryManitoLabel: UILabel!
    @IBOutlet weak var fromManitiFirstView: UIView!
    @IBOutlet weak var fromManitiSecondView: UIView!
    @IBOutlet weak var fromManitiSecondLabel: UILabel!
    @IBOutlet weak var fromManitiThirdView: UIView!
    @IBOutlet weak var fromManitiForthView: UIView!
    @IBOutlet weak var fromManitiForthLabel: UILabel!
    @IBOutlet weak var manitiIconBackView: UIView!
    @IBOutlet weak var manitiIconView: UIImageView!
    @IBOutlet weak var manitiNickLabel: UILabel!
    @IBOutlet var memoriIconBottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentControl()
        setupFont()
        setupViewLayer()
   }
    
    private func setupSegmentControl() {
        let font = UIFont.font(.regular, ofSize: 14)
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: font]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: font]
 
        memoryControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        memoryControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        memoryControl.selectedSegmentTintColor = .white
        memoryControl.backgroundColor = .darkGrey004
    }
    
    private func setupFont() {
        memoryManitoLabel.font = .font(.regular, ofSize: 15)
        fromManitiSecondLabel.font = .font(.regular, ofSize: 14)
        fromManitiForthLabel.font = .font(.regular, ofSize: 14)
        manitiNickLabel.font = .font(.regular, ofSize: 30)
    }
    
    private func setupViewLayer() {
        fromManitiFirstView.makeBorderLayer(color: .white)
        fromManitiSecondView.makeBorderLayer(color: .white)
        fromManitiThirdView.makeBorderLayer(color: .white)
        fromManitiForthView.makeBorderLayer(color: .white)
        manitiIconBackView.layer.cornerRadius = 50
        manitiIconView.layer.cornerRadius = 50
    }
}
