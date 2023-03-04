//
//  ThrottleButton.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/04.
//

import UIKit

class ThrottleButton: UIButton {

    // MARK: - property

    private var workItem: DispatchWorkItem?
    private var delay: Double = 0
    private var callback: (() -> Void)?

    // MARK: - init

    deinit {
        self.removeTarget(self, action: #selector(self.performCallback(_:)), for: .touchUpInside)
    }

    // MARK: - func

    func throttle(delay: Double, callback: @escaping (() -> Void)) {
        self.delay = delay
        self.callback = callback

        self.addTarget(self, action: #selector(self.performCallback(_:)), for: .touchUpInside)
    }

    // MARK: - selector

    @objc
    private func performCallback(_ sender: UIButton) {
        if self.workItem == nil {
            self.callback?()

            let workItem = DispatchWorkItem(block: { [weak self] in
                self?.workItem?.cancel()
                self?.workItem = nil
            })
            self.workItem = workItem

            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay, execute: workItem)
        }
    }
}
