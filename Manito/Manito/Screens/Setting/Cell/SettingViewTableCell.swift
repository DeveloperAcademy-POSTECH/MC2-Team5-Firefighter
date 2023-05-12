//
//  SettingViewTableCell.swift
//  Manito
//
//  Created by LeeSungHo on 2022/07/07.
//

import UIKit

import SnapKit

class SettingViewTableCell: UITableViewCell {
    
    // MARK: - ui component
    
    private let settingCellView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 10
        view.backgroundColor = .darkGrey002
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.settingCellView)
        self.settingCellView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        self.settingCellView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    private func configureUI() {
        self.backgroundColor = .backgroundGrey
        self.selectionStyle = .none
    }
    
    func configureCell(title: String) {
        DispatchQueue.main.async {
            self.titleLabel.text = title
        }
    }
}
