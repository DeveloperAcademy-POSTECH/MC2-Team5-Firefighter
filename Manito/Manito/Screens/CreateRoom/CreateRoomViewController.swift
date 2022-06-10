//
//  CreateRoomViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

class CreateRoomViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var roomsNameTextField: UITextField!
    
    lazy var roomsTextLimit : UILabel = {
        let label = UILabel()
        label.text = "0/8"
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 20)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CustomazingTextField()
        // Do any additional setup after loading the view.
        
        
    }
    
    // MARK: - Functions
    func CustomazingTextField(){
        roomsNameTextField.backgroundColor = UIColor.fieldGray
//        roomsNameTextField.placeholder = "방 이름을 적어주세요"
        roomsNameTextField.attributedPlaceholder = NSAttributedString(string: "방 이름을 적어주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        roomsNameTextField.layer.cornerRadius = 10
        roomsNameTextField.layer.masksToBounds = true
        roomsNameTextField.layer.borderWidth = 1
        roomsNameTextField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    
    // MARK: - Navigation


}
