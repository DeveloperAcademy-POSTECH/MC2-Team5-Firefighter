//
//  BaseViewControllerType.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/06.
//

import UIKit

///
/// UIViewController 타입의 클래스를 구성하기 위한 기본적인 함수를 제공합니다.
///

@available(iOS, deprecated, message: "아직 리팩토링을 하지 않은 화면이 남아있어서 임시적으로 만든 프로토콜입니다.")
protocol BaseViewControllerType: UIViewController {
    func setupLayout()
    func configureUI()
}

extension BaseViewControllerType {
    func baseViewDidLoad() {
        self.setupLayout()
        self.configureUI()
    }
}
