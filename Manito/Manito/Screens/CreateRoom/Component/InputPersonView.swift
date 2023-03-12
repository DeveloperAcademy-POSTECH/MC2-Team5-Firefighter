//
//  InputPersonView.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/11.
//

import UIKit

import SnapKit

final class InputPersonView: UIView {
    
    // MARK: - ui component
    
    private let personViewLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.inputPersonViewTitle
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    private let personBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.makeBorderLayer(color: .subOrange)
        return view
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.imgNi
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    private lazy var personLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.x + " \(Int(personSlider.value))인"
        label.font = .font(.regular, ofSize: 24)
        return label
    }()
    lazy var personSlider: UISlider = {
        let slider = UISlider()
        slider.value = 1
        slider.minimumValue = 4
        slider.maximumValue = 15
        slider.tintColor = .mainRed
        slider.setThumbImage(ImageLiterals.imageSliderThumb, for: .normal)
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        return slider
    }()
    private lazy var minLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Int(personSlider.minimumValue))인"
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private lazy var maxLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Int(personSlider.maximumValue))인"
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        self.personLabel.text = TextLiteral.x + " \(Int(value))인"
    }
    
    // MARK: - func
    
    private func setLayout() {
        self.addSubview(personViewLabel)
        self.personViewLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(personBackView)
        self.personBackView.snp.makeConstraints {
            $0.top.equalTo(personViewLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        self.personBackView.addSubview(personLabel)
        self.personLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        self.personBackView.addSubview(imageView)
        self.imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(personLabel.snp.leading)
            $0.width.height.equalTo(60)
        }
        
        self.addSubview(minLabel)
        self.minLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.top.equalTo(personBackView.snp.bottom).offset(49)
        }
        
        self.addSubview(maxLabel)
        self.maxLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.top.equalTo(minLabel.snp.top)
        }
        
        self.addSubview(personSlider)
        self.personSlider.snp.makeConstraints {
            $0.centerY.equalTo(minLabel.snp.centerY)
            $0.trailing.equalTo(maxLabel.snp.leading).offset(-5)
            $0.leading.equalTo(minLabel.snp.trailing).offset(5)
        }
    }
}
