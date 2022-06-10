//
//  DetailWaitViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

class DetailWaitViewController: UIViewController {
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var startStatus: UILabel!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var durationText: UILabel!
    @IBOutlet weak var durationDateText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor
        setRoomTitle(label: roomTitle)
        setStartStatus(label: startStatus)
        setDurationView(view: durationView)
        setDurationTitle(label: durationText)
        setDurationDateText(label: durationDateText)

        // Do any additional setup after loading the view.
    }

    func setRoomTitle(label: UILabel) {
        label.textColor = .white
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 34)
    }
    
    func setStartStatus(label: UILabel) {
        label.backgroundColor = .waitBackgroundColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11
        label.textColor = .waitTextColor
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 13)
        label.textAlignment = .center
    }
    
    func setDurationView(view: UIView) {
        view.backgroundColor = .durationBackgroundColor
        view.layer.cornerRadius = 8
    }
    
    func setDurationTitle(label: UILabel) {
        label.textColor = .grey4
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 14)
    }
    
    func setDurationDateText(label: UILabel) {
        label.textColor = .white
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 18)
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
