//
//  CreateRoomViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

class CreateRoomViewController: UIViewController {

    // MARK: - Property
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "방 생성하기"
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 34)
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.tintColor = .lightGray
        btn.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return btn
    }()
    
    lazy var createView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
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
        btn.addTarget(self, action: #selector(didTapnextButoon), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureComponent()
        
    }
    
    // MARK: - Selectors
    @objc func didTapCloseButton(){
        print("ttaapp")
    }
    
    @objc func didTapnextButoon(){
        print("tap")
    }
    

    // MARK: - Configure
    func configure(){
        
    }
    
    func configureComponent(){
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 66).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16).isActive = true
        
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
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
