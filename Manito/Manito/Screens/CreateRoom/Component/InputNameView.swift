//
//  InputNameView.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/11.
//

import UIKit

class InputNameView: UIView {
    
    // MARK: - Property
    private let roomsNameTextField: UITextField = {
        let texField = UITextField()
        texField.backgroundColor = UIColor.subBackgroundGrey
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: AppFontName.regular.rawValue, size: 18)!
        ]
        texField.attributedPlaceholder = NSAttributedString(string: "방 이름을 적어주세요", attributes:attributes)
        
        texField.layer.cornerRadius = 10
        texField.layer.masksToBounds = true
        texField.layer.borderWidth = 1
        texField.layer.borderColor = UIColor.lightGray.cgColor
        texField.textAlignment = .center
        return texField
    }()
    
    private let roomsTextLimit : UILabel = {
        let label = UILabel()
        label.text = "0/8"
        label.font = .font(.regular, ofSize: 20)
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Config
    private func render(){
        
        self.addSubview(roomsNameTextField)
        roomsNameTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.addSubview(roomsTextLimit)
        roomsTextLimit.snp.makeConstraints {
            $0.top.equalTo(roomsNameTextField.snp.bottom).inset(-10)
            $0.right.equalToSuperview()
        }
    }
}
