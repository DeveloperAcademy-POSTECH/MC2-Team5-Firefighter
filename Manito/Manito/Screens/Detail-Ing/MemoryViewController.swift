//
//  MemoryViewController.swift
//  Manito
//
//  Created by 최성희 on 2022/06/14.
//

import UIKit

class MemoryViewController: UIViewController {
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

        setupFont()
        setupViewLayer()
        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
