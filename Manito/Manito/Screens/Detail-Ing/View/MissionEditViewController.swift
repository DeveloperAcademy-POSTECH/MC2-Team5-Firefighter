//
//  MissionEditViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/06/19.
//

import UIKit

import SnapKit

final class MissionEditViewController: BaseViewController {
    
    // MARK: - component
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        view.backgroundColor = .darkGrey004
        return view
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGesture()
    }
    
    override func configureUI() {
        super.configureUI()
        self.view.backgroundColor = .darkGrey001.withAlphaComponent(0.5)
    }
    
    override func setupLayout() {
        self.view.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(120)
        }
    }
    
    // MARK: - func
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - selector
    
    @objc
    private func dismissViewController() {
        self.dismiss(animated: true)
    }
}
