//
//  Navigationable.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/09/11.
//

import UIKit

protocol Navigationable: UIGestureRecognizerDelegate {
    func setupNavigation()
}

extension Navigationable where Self: UIViewController {
    func setupNavigation() {
        self.setupNavigationBar()
        self.setupBackButton()
        self.setDragPopGesture(self)
//        self.hidekeyboardWhenTappedAround()
    }
    
    private func backButtonItem() -> UIBarButtonItem {
        let button = BackButton()
        let buttonAction = UIAction { [weak self] _ in
            self?.back()
        }
        button.addAction(buttonAction, for: .touchUpInside)
        let leftOffsetBackButton = self.removeBarButtonItemOffset(with: button, offsetX: 10)
        let backButton = self.makeBarButtonItem(with: leftOffsetBackButton)
        return backButton
    }
    
    private func setupBackButton() {
        let backButton = self.backButtonItem()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func back() {
        if let navigation = self.navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        let font = UIFont.font(.regular, ofSize: 14)
        let largeFont = UIFont.font(.regular, ofSize: 34)
        
        appearance.titleTextAttributes = [.font: font]
        appearance.largeTitleTextAttributes = [.font: largeFont]
        appearance.shadowColor = .clear
        appearance.backgroundColor = .backgroundGrey
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setDragPopGesture(_ vc: Navigationable) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = vc
    }
}
