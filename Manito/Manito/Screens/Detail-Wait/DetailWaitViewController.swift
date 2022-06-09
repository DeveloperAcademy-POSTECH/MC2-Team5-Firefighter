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

    override func viewDidLoad() {
        super.viewDidLoad()
        roomTitle.textColor = .white
        roomTitle.font = UIFont(name: "DungGeunMo", size: 34)

        // MARK: 강제로 맞춘거라 어떻게 해야 유연하게 바뀌는지 모르겠음
        startStatus.frame = CGRect(x: 200, y: 130, width: 66, height: 23)
        startStatus.backgroundColor = .waitBackgroundColor
        startStatus.layer.masksToBounds = true
        startStatus.layer.cornerRadius = 11
        startStatus.textColor = .waitTextColor
        startStatus.font = UIFont(name: "DungGeunMo", size: 13)
        startStatus.textAlignment = .center

        // Do any additional setup after loading the view.
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
