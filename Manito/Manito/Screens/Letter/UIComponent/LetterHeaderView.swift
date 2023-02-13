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
        let font = UIFont.font(.regular, ofSize: 14)
        let control = UISegmentedControl(items: [TextLiteral.letterHeaderViewSegmentControlManitti,
                                                 TextLiteral.letterHeaderViewSegmentControlManitto])
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                    NSAttributedString.Key.font: font]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                      NSAttributedString.Key.font: font]
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        control.selectedSegmentTintColor = .white
        control.backgroundColor = .darkGrey004
        control.addTarget(self, action: #selector(self.segmentedControlIndexValueChanged(_:)), for: .valueChanged)
        return control
    }()

    // MARK: - property

    private var segmentedControlIndex: Int = 0 {
        didSet {
            self.segmentedControl.selectedSegmentIndex = self.segmentedControlIndex
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.segmentedControl)
        self.segmentedControl.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(13)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(40)
        }
    }
    
    private func configureUI() {
        self.backgroundColor = .backgroundGrey
    }

    func setSegmentedControlIndex(_ index: Int) {
        self.segmentedControlIndex = index
    }
    
    // MARK: - selector
    
    @objc
    private func segmentedControlIndexValueChanged(_ segmentedControl: UISegmentedControl) {
        self.segmentedControlIndex = segmentedControl.selectedSegmentIndex
        self.selectedSegmentIndexDidChange?(self.segmentedControlIndex)
    }
}
