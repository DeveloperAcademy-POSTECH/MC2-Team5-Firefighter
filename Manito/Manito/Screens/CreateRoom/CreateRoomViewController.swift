//
//  CreateRoomViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

class CreateRoomViewController: UIViewController {

    // MARK: - Property
    
    lazy var createView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "방 생성하기"
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 34)
        return label
    }()
    
    lazy var roomsNameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.fieldGray
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: AppFontName.regular.rawValue, size: 18)!
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "방 이름을 적어주세요", attributes:attributes)
        tf.layer.cornerRadius = 10
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.textAlignment = .center
        return tf
    }()
    
    lazy var roomsTextLimit : UILabel = {
        let label = UILabel()
        label.text = "0/8"
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 20)
        return label
    }()
    
    lazy var nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("다음", for: .normal)
        btn.titleLabel?.font = UIFont(name: AppFontName.regular.rawValue, size: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.dinnerRed
        btn.layer.cornerRadius = 30
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureComponent()
        
    }
    
    // MARK: - Configure
    func configure(){
        
    }
    
    func configureComponent(){
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 66).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16).isActive = true
        
        view.addSubview(createView)
        createView.translatesAutoresizingMaskIntoConstraints = false
        createView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 66).isActive = true
        createView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        createView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -16).isActive = true
        createView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        

        configureRoomsTitle()
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -16).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -57).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    func configureRoomsTitle(){

        createView.addSubview(roomsNameTextField)
        roomsNameTextField.translatesAutoresizingMaskIntoConstraints = false
        roomsNameTextField.topAnchor.constraint(equalTo: createView.topAnchor).isActive = true
        roomsNameTextField.leftAnchor.constraint(equalTo: createView.leftAnchor).isActive = true
        roomsNameTextField.rightAnchor.constraint(equalTo: createView.rightAnchor).isActive = true
        roomsNameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        createView.addSubview(roomsTextLimit)
        roomsTextLimit.translatesAutoresizingMaskIntoConstraints = false
        roomsTextLimit.topAnchor.constraint(equalTo: roomsNameTextField.bottomAnchor, constant: 10).isActive = true
        roomsTextLimit.rightAnchor.constraint(equalTo: createView.rightAnchor).isActive = true
    }
    
    // MARK: - Navigation


}
