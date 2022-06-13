//
//  UILabel+Extension.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/12.
//

import UIKit

extension UILabel {
    func addLabelSpacing(kernValue: Double = 0.0, lineSpacing: CGFloat = 6.0) {
        if let labelText = self.text, labelText.count > 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            attributedText = NSAttributedString(string: labelText,
                                                attributes: [.kern: kernValue,
                                                             .paragraphStyle: paragraphStyle])
            lineBreakStrategy = .hangulWordPriority
        }
    }
}
