//
//  CreateRoomCollectionCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/13.
//

import UIKit

import SnapKit

final class CreateRoomCollectionViewCell: UICollectionViewCell, BaseViewType {
    
    // MARK: - ui component
    
    private let imageView: UIImageView = UIImageView(image: UIImage.Icon.newRoom)    
    private let circleView: UIView = {
        let circleView = UIView()
        circleView.backgroundColor = .yellow001
        circleView.layer.cornerRadius = 44
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.grey003.cgColor
        return circleView
    }()
    private let menuLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.Main.cellCreateRoomTitle.localized()
        label.textColor = .grey001
        label.font = .font(.regular, ofSize: 14)
        return label
    }()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubview(self.circleView)
        self.circleView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(88)
        }
        
        self.circleView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints {
            $0.width.height.equalTo(72)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(13)
        }
        
        self.addSubview(self.menuLabel)
        self.menuLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureUI(){
        self.backgroundColor = .darkGrey002.withAlphaComponent(0.8)
        self.makeBorderLayer(color: UIColor.white.withAlphaComponent(0.5))
    }
}
