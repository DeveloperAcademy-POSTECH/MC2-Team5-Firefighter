//
//  LetterHeaderView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

import SnapKit

final class LetterHeaderView: UICollectionReusableView {
    
    var selectedSegmentIndexDidChange: ((_ changedIndex: Int) -> ())?
    
    // MARK: - ui component
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [TextLiteral.letterHeaderViewSegmentControlManitti, TextLiteral.letterHeaderViewSegmentControlManitto])
        let font = UIFont.font(.regular, ofSize: 14)
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: font]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: font]
        
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        control.selectedSegmentTintColor = .white
        control.backgroundColor = .darkGrey004
        control.addTarget(self, action: #selector(segmentedControlIndexValueChanged(_:)), for: .valueChanged)
        
        return control
    }()

    // MARK: - property

    var segmentedControlIndex: Int = 0 {
        didSet {
            segmentedControl.selectedSegmentIndex = segmentedControlIndex
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(13)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(40)
        }
    }
    
    private func configureUI() {
        backgroundColor = .backgroundGrey
    }
    
    // MARK: - selector
    
    @objc
    private func segmentedControlIndexValueChanged(_ sender: UISegmentedControl) {
        segmentedControlIndex = sender.selectedSegmentIndex
        selectedSegmentIndexDidChange?(segmentedControlIndex)
    }
}
