//
//  LetterCollectionReusableView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

import SnapKit

final class LetterCollectionReusableView: UICollectionReusableView {
    
    private enum LetterState: String, CaseIterable {
        case received = "받은 쪽지"
        case sent = "보낸 쪽지"
    }
    
    // MARK: - property
    
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [LetterState.received.rawValue,
                                                 LetterState.sent.rawValue])
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        control.selectedSegmentTintColor = .white
        control.backgroundColor = .darkGrey003
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
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
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
    
    private func configUI() {
        backgroundColor = .backgroundGrey
    }
}
