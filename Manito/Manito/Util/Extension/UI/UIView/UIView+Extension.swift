//
//  UIView+Extension.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

extension UIView {
    // FIXME: - CalendarView, CreateLetterPhotoView 내부에서 삭제한 후 제거 예정
    var viewController: UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.viewController
        } else {
            return nil
        }
    }
    
    @discardableResult
    func makeShadow(color: UIColor,
                    opacity: Float,
                    offset: CGSize,
                    radius: CGFloat) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        return self
    }
    
    @discardableResult
    func makeBorderLayer(color: UIColor) -> Self {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
        return self
    }
}
