//
//  BaseViewType.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/05.
//

import UIKit

///
/// UIView 타입의 클래스를 구성하기 위한 기본적인 함수를 제공합니다.
///

protocol BaseViewType: UIView {
    func setupLayout()
    func configureUI()
}

extension BaseViewType {
    /// 기본적인 메서드를 한 번에 호출하는 메서드
    func baseInit() {
        self.setupLayout()
        self.configureUI()
    }
}
