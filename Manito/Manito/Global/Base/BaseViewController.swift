//
//  BaseViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - property
    
    private lazy var backButton: UIButton = {
        let button = BackButton()
        let buttonAction = UIAction { _ in
            self.navigationController?.popViewController(animated: true)
        }
        button.addAction(buttonAction, for: .touchUpInside)
        return button
    }()
    lazy var guideButton = UIButton()
    lazy var guideBoxImageView = UIImageView(image: ImageLiterals.imgGuideBox)
    lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .font(.regular, ofSize: 14)
        label.contentMode = .center
        return label
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
        setupBackButton()
        hidekeyboardWhenTappedAround()
        setupNavigationBar()
        setupNavigationPopGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func render() {
        // Override Layout
    }
    
    func configUI() {
        view.backgroundColor = .backgroundGrey
    }
    
    func setupNavigationBar() {
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
    
    // MARK: - helper func
    
    func makeBarButtonItem<T: UIView>(with view: T) -> UIBarButtonItem {
        return UIBarButtonItem(customView: view)
    }
    
    func removeBarButtonItemOffset(with button: UIButton, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIView {
        let offsetView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        offsetView.bounds = offsetView.bounds.offsetBy(dx: offsetX, dy: offsetY)
        offsetView.addSubview(button)
        return offsetView
    }
    
    func renderGuideArea() {
        view.addSubview(guideBoxImageView)
        guideBoxImageView.snp.makeConstraints {
            $0.top.equalTo(guideButton.snp.bottom).offset(-10)
            $0.trailing.equalTo(guideButton.snp.trailing).offset(-12)
            $0.width.equalTo(270)
            $0.height.equalTo(90)
        }
        
        guideBoxImageView.addSubview(guideLabel)
        guideLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    func setupGuideArea() {
        let guideAction = UIAction { [weak self] _ in
            self?.guideBoxImageView.isHidden.toggle()
        }
        guideButton.addAction(guideAction, for: .touchUpInside)
        guideBoxImageView.isHidden = true
    }
    
    func setupGuideText(title: String, text: String) {
        guideLabel.text = text
        guideLabel.addLabelSpacing()
        guideLabel.textAlignment = .center
        guideLabel.applyColor(to: title, with: .subOrange)
    }
    
    // MARK: - private func
    
    private func setupBackButton() {
        let leftOffsetBackButton = removeBarButtonItemOffset(with: backButton, offsetX: 10)
        let backButton = makeBarButtonItem(with: leftOffsetBackButton)
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupNavigationPopGesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
