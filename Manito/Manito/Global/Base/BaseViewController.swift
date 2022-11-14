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
        let buttonAction = UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
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
    
    private let tokenService: TokenAPI = TokenAPI(apiService: APIService())
    
    // MARK: - init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("success deallocation")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
        setupBackButton()
        hidekeyboardWhenTappedAround()
        setupNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInteractivePopGestureRecognizer()
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

    private func setupInteractivePopGestureRecognizer() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = .grey001
        toastLabel.textColor = .black
        toastLabel.font = .font(.regular, ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(150)
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }
        UIView.animate(withDuration: 0.7, animations: {
            toastLabel.alpha = 0.8
        }, completion: { isCompleted in
            UIView.animate(withDuration: 0.7, delay: 0.5, animations: {
                toastLabel.alpha = 0
            }, completion: { isCompleted in
                toastLabel.removeFromSuperview()
            })
        })
    }
    
    func touchUpToShowToast(code: String) {
        UIPasteboard.general.string = code
        self.showToast(message: TextLiteral.detailWaitViewControllerCopyCode)
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let count = self.navigationController?.viewControllers.count else { return false }
        return count > 1
    }
}
