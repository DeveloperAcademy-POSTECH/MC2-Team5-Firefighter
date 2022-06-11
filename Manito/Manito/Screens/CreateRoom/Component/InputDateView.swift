//
//  InputDateView.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/11.
//

import UIKit

class InputDateView: UIView {
    
    // MARK: - Property
    // 방 기한 설정 뷰
    private let dateViewLabel: UILabel = {
        let label = UILabel()
        label.text = "활동 기간을 설정해 주세요"
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    
    private let dateBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.subOrange.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2022.06.06 ~ 2022.06.11"
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
    
    // MARK: - Selector
    @objc func didTapDateBackView(_ gesture: UITapGestureRecognizer){
        print("gesture")
    }
    
    // MARK: - Config
    func render(){
        
        self.addSubview(dateViewLabel)
        dateViewLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(dateBackView)
        dateBackView.snp.makeConstraints {
            $0.top.equalTo(dateViewLabel.snp.bottom).inset(-36)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        dateBackView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        let gestureTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapDateBackView(_:)))
        gestureTapRecognizer.numberOfTapsRequired = 1
        gestureTapRecognizer.numberOfTouchesRequired = 1
        self.addGestureRecognizer(gestureTapRecognizer)
        
    }
}
