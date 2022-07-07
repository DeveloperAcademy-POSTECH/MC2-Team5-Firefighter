//
//  SettingViewTableCell.swift
//  Manito
//
//  Created by LeeSungHo on 2022/07/07.
//

import UIKit

import SnapKit

class SettingViewTableCell : UITableViewCell {
    
    static let identifier = "SettingViewTableCell"
    
    // MARK: - Property
    lazy var settingCellView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 10
        view.backgroundColor = .darkGrey002
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .backgroundGrey
        render()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    // MARK: - render
    private func render() {
        
        self.addSubview(settingCellView)
        settingCellView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        settingCellView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
    }
}
