//
//  FriendCollectionViewCell.swift
//  Manito
//
//  Created by 최성희 on 2022/06/13.
//

import UIKit

import SnapKit

final class FriendCollectionViewCell: UICollectionViewCell, BaseViewType {

    // MARK: - ui component
    
    private let friendBackView: UIView = {
        let view = UIView()
        view.makeBorderLayer(color: .white)
        view.layer.cornerRadius = 49
        return view
    }()
    private let friendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 45
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let friendNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 15)
        label.textAlignment = .center
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
    
    // MARK: - base view
    
    func setupLayout() {
        self.addSubview(self.friendBackView)
        self.friendBackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
        
        self.friendBackView.addSubview(self.friendImageView)
        self.friendImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
            $0.width.height.equalTo(90)
        }
        
        self.addSubview(self.friendNicknameLabel)
        self.friendNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(self.friendBackView.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(16)
        }
    }
    
    func configureUI() {
        self.backgroundColor = .white.withAlphaComponent(0.3)
        self.makeBorderLayer(color: .white)
    }
    
    // MARK: - func
    
    func configureCell(name: String, colorIndex: Int) {
        self.friendNicknameLabel.text = name
        self.friendBackView.backgroundColor = DefaultCharacterType.allCases[colorIndex].backgroundColor
        self.friendImageView.image = DefaultCharacterType.allCases[colorIndex].image
    }
}
