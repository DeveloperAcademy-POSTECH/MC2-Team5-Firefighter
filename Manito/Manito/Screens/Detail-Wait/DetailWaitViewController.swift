//
//  DetailWaitViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit
import SnapKit

class DetailWaitViewController: BaseViewController {
    private let roomTitle: UILabel = {
        let label = UILabel()
        label.text = "명예소방관"
        label.textColor = .white
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 34)
        return label
    }()

    private let startStauts: UILabel = {
        let label = UILabel()
        // MARK: enum으로 만드는게 좋아보임
        label.text = "대기중"
        label.backgroundColor = .waitBackgroundColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11
        label.textColor = .waitTextColor
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 13)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor
        render()
        // Do any additional setup after loading the view.
    }

    override func render() {
        view.addSubview(roomTitle)
        roomTitle.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
        }

        view.addSubview(startStauts)
        startStauts.snp.makeConstraints {
            $0.centerY.equalTo(roomTitle.snp.centerY)
            $0.left.equalTo(roomTitle.snp.right).inset(-10)
            $0.width.equalTo(66)
            $0.height.equalTo(23)
        }
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
