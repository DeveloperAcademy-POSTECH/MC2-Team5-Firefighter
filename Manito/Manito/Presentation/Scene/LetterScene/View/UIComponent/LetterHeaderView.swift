//
//  LetterHeaderView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import Combine
import UIKit

import SnapKit

final class LetterHeaderView: UICollectionReusableView {
    
    // MARK: - ui component
    
    private let segmentedControl: UISegmentedControl = {
        let font = UIFont.font(.regular, ofSize: 14)
        let control = UISegmentedControl(items: [TextLiteral.Letter.manitteTitle.localized(),
                                                 TextLiteral.Letter.manittoTitle.localized()])
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

    var segmentedControlTapPublisher: AnyPublisher<Int, Never> {
        return self.segmentedControl.tapPublisher
            .compactMap { [weak self] in self?.segmentedControl.selectedSegmentIndex }
            .eraseToAnyPublisher()
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func

    func setupHeaderSelectedIndex(at index: Int) {
        self.segmentedControl.selectedSegmentIndex = index
    }

    private func setupLayout() {
        self.addSubview(self.segmentedControl)
        self.segmentedControl.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(13)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.height.equalTo(40)
        }
    }

    private func configureUI() {
        self.backgroundColor = .backgroundGrey
    }
}
