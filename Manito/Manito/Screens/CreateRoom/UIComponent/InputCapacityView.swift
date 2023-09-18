//
//  InputPersonView.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/11.
//

import Combine
import UIKit

import SnapKit

final class InputCapacityView: UIView {
    
    // MARK: - ui component
    
    private let titleLabel: UILabel = {
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
        imageView.image = UIImage.Image.ni
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    private lazy var personLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.x + " \(Int(self.personSlider.value))인"
        label.font = .font(.regular, ofSize: 24)
        return label
    }()
    private lazy var personSlider: UISlider = {
        let slider = UISlider()
        slider.value = 1
        slider.minimumValue = 4
        slider.maximumValue = 15
        slider.tintColor = .mainRed
        slider.setThumbImage(UIImage.Image.sliderThumb, for: .normal)
        slider.addTarget(self, action: #selector(self.didSlideSlider(_:)), for: .valueChanged)
        return slider
    }()
    private lazy var minLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Int(self.personSlider.minimumValue))인"
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private lazy var maxLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Int(self.personSlider.maximumValue))인"
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    
    let sliderPublisher = PassthroughSubject<Int, Never>()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(self.personBackView)
        self.personBackView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        self.personBackView.addSubview(self.personLabel)
        self.personLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        self.personBackView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(self.personLabel.snp.leading)
            $0.width.height.equalTo(60)
        }
        
        self.addSubview(self.minLabel)
        self.minLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.top.equalTo(self.personBackView.snp.bottom).offset(49)
        }
        
        self.addSubview(self.maxLabel)
        self.maxLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.top.equalTo(self.minLabel.snp.top)
        }
        
        self.addSubview(self.personSlider)
        self.personSlider.snp.makeConstraints {
            $0.centerY.equalTo(self.minLabel.snp.centerY)
            $0.trailing.equalTo(self.maxLabel.snp.leading).offset(-5)
            $0.leading.equalTo(self.minLabel.snp.trailing).offset(5)
        }
    }
    
    func updateCapacity(capacity: Int) {
        self.personLabel.text = TextLiteral.x + " \(capacity)인"
    }
    
    // MARK: - selector
    
    @objc
    private func didSlideSlider(_ slider: UISlider) {
        let value = Int(slider.value)
        self.sliderPublisher.send(value)
    }
}
