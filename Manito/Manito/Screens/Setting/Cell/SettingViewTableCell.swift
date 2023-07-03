//
//  SettingViewTableCell.swift
//  Manito
//
//  Created by LeeSungHo on 2022/07/07.
//

import UIKit

import SnapKit

final class SettingViewTableCell: UITableViewCell {
    
    // MARK: - ui component

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
        self.configureContentViewLayer()
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
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    private func configureUI() {
        self.backgroundColor = .backgroundGrey
        self.selectionStyle = .none
    }
    
    private func configureContentViewLayer() {
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.cornerRadius = 10
        self.contentView.backgroundColor = .darkGrey002
    }
    
    func configureCell(title: String) {
        self.titleLabel.text = title
    }
}
