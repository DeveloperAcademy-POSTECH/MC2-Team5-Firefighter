//
//  CreateRoomViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class CreateRoomViewController: BaseViewController {
    
    private var index = 0
    
    // MARK: - Property
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "방 생성하기"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(ImageLiterals.xmark, for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: MainButton = {
        let button = MainButton()
        button.title = "다음"
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private let nameView: InputNameView = {
        let view = InputNameView()
        view.isHidden = false
        return view
        
    }()
    
    private let personView: InputPersonView = {
        let view = InputPersonView()
        view.isHidden = true
        return view
    }()
    
    private let dateView: InputDateView = {
        let view = InputDateView()
        view.isHidden = true
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func render() {
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.width.height.equalTo(44)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(57)
            $0.height.equalTo(60)
        }
        
        view.addSubview(nameView)
        nameView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        view.addSubview(personView)
        personView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        view.addSubview(dateView)
        dateView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }
    
    // MARK: - Configure
    override func configUI() {
        super.configUI()
        view.backgroundColor = .backgroundGrey
    }
    
    // MARK: - Selectors
    @objc private func didTapCloseButton() {
        print("ttaapp")
    }
    
    @objc private func didTapNextButton() {
        print("tap")
        index += 1
        changedInputView()
    }
    
    // MARK: - Functions
    private func changedInputView() {
        if index % 3 == 0 {
            self.nameView.isHidden = false
            self.personView.isHidden = true
            self.dateView.isHidden = true
        }
        else if index % 3 == 1 {
            self.nameView.isHidden = true
            self.personView.isHidden = false
            self.dateView.isHidden = true
        }
        else {
            self.nameView.isHidden = true
            self.personView.isHidden = true
            self.dateView.isHidden = false
        }
    }
}
