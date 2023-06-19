//
//  MissionEditViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/06/19.
//

import UIKit

import SnapKit

final class MissionEditViewController: BaseViewController {
    
    let mission: String
    
    // MARK: - component
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        view.backgroundColor = .darkGrey004
        return view
    }()
    private lazy var missionTextField: UITextField = {
        let textField = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont.font(.regular, ofSize: 18)
        ]
        textField.backgroundColor = .darkGrey002
        textField.attributedPlaceholder = NSAttributedString(string: self.mission, attributes:attributes)
        textField.font = .font(.regular, ofSize: 18)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.becomeFirstResponder()
        return textField
    }()
    
    init(mission: String) {
        self.mission = mission
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        self.view.addSubview(missionTextField)
        self.missionTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.center.equalToSuperview()
            $0.height.equalTo(60)
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
