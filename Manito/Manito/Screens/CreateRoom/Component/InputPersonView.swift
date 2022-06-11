//
//  InputPersonView.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/11.
//

import UIKit

import SnapKit

class InputPersonView: UIView {
    
    // MARK: - Property
    private let peronsViewLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 참여 인원을 설정해 주세요"
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    
    private let personBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.subOrange.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "heart")
        iv.backgroundColor = .darkGray
        return iv
    }()
    
    private var personLabel: UILabel = {
        let label = UILabel()
        label.text = "X 5인"
        label.font = .font(.regular, ofSize: 24)
        return label
    }()
    
    lazy var personSlider: UISlider = {
        let slider = UISlider()
        slider.value = 1
        slider.minimumValue = 5
        slider.maximumValue = 15
        slider.addTarget(self, action: #selector(didSlider(_:)), for: .valueChanged)
        return slider
    }()
    
    private var minLabel: UILabel = {
        let label = UILabel()
        label.text = "5인"
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    
    private var maxLabel: UILabel = {
        let label = UILabel()
        label.text = "15인"
        label.font = .font(.regular, ofSize: 16)
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
    
    // MARK: - Selector
    @objc func didSlider(_ slider: UISlider){
        let value = slider.value
        personLabel.text = "X \(Int(value))인"
    }
    
    // MARK: - Config
    private func render(){
        
        self.addSubview(peronsViewLabel)
        peronsViewLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(personBackView)
        personBackView.snp.makeConstraints {
            $0.top.equalTo(peronsViewLabel.snp.bottom).inset(-36)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        personBackView.addSubview(personLabel)
        personLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        personBackView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(personLabel.snp.leading)
            $0.width.height.equalTo(60)
        }
        
        self.addSubview(minLabel)
        minLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(personBackView.snp.bottom).offset(49)
        }
        
        self.addSubview(maxLabel)
        maxLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(minLabel.snp.top)
        }
        
        self.addSubview(personSlider)
        personSlider.snp.makeConstraints {
            $0.centerY.equalTo(minLabel.snp.centerY)
            $0.trailing.equalTo(maxLabel.snp.leading).offset(-5)
            $0.leading.equalTo(minLabel.snp.trailing).offset(5)
        }
    }
}
