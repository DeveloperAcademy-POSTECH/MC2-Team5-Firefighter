//
//  LetterHeaderView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

import SnapKit

final class LetterHeaderView: UICollectionReusableView {
    
    var changeSegmentControlIndex: ((Int) -> ())?
    
    // MARK: - property
    
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["받은 쪽지", "보낸 쪽지"])
        let font = UIFont.font(.regular, ofSize: 14)
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: font]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: font]
        
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        control.selectedSegmentTintColor = .white
        control.backgroundColor = .darkGrey004
        control.addTarget(self, action: #selector(changedIndexValue(_:)), for: .valueChanged)
        
        return control
    }()
    
    var segmentControlIndex: Int = 0 {
        didSet {
            segmentControl.selectedSegmentIndex = segmentControlIndex
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
        self.addSubview(segmentControl)
        segmentControl.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(13)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(40)
        }
    }
    
    private func configUI() {
        backgroundColor = .backgroundGrey
    }
    
    // MARK: - selector
    
    @objc
    private func changedIndexValue(_ sender: UISegmentedControl) {
        segmentControlIndex = sender.selectedSegmentIndex
        changeSegmentControlIndex?(segmentControlIndex)
    }
}
