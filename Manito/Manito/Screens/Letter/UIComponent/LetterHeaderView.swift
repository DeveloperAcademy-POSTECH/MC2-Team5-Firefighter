//
//  LetterHeaderView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

import SnapKit

protocol LetterHeaderViewDelegate: AnyObject {
    func selectedSegmentIndexDidChange(index: Int)
}

final class LetterHeaderView: UICollectionReusableView {
    
    // MARK: - ui component
    
    private let segmentedControl: UISegmentedControl = {
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
        return control
    }()

    // MARK: - property

    private weak var delegate: LetterHeaderViewDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.configureUI()
        self.setupSelectedSegmentIndex()
        self.setupAction()
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

    // TODO: - type으로 바뀌도록 수정
    private func setupSelectedSegmentIndex() {
        self.segmentedControl.selectedSegmentIndex = 0
    }

    private func setupAction() {
        let valueChangedAction = UIAction { [weak self] action in
            guard let sender = action.sender as? UISegmentedControl else { return }
            self?.segmentedControlIndexValueChanged(sender)
        }
        self.segmentedControl.addAction(valueChangedAction, for: .valueChanged)
    }

    private func segmentedControlIndexValueChanged(_ segmentedControl: UISegmentedControl) {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        self.delegate?.selectedSegmentIndexDidChange(index: selectedSegmentIndex)
    }

    func configureDelegation(_ delegate: LetterHeaderViewDelegate) {
        self.delegate = delegate
    }
}
