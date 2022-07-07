//
//  LoginViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/07.
//

import UIKit

import SnapKit

class LoginViewController: BaseViewController {

    // MARK: - property

//    private let logoImageView = UIImageView(image: ImageLiterals.)
    private let logoImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func render() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-92)
            $0.width.height.equalTo(130)
        }
    }
}
