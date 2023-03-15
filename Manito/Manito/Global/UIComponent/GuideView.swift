//
//  GuideView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/09.
//

import UIKit

import SnapKit

final class GuideView: UIView {

    enum GuideType: String {
        case letter
        case main
        case detailing

        var text: String {
            switch self {
            case .letter: return TextLiteral.letterViewControllerGuideText
            case .main: return TextLiteral.mainViewControllerGuideDescription
            case .detailing: return TextLiteral.detailIngViewControllerGuideTitle
            }
        }

        var image: UIImage {
            switch self {
            case .letter: return ImageLiterals.icLetterInfo
            default: return ImageLiterals.icMissionInfo
            }
        }
    }

    // MARK: - ui component

    private let guideButton: UIButton = UIButton()
    private let guideBoxImageView: UIImageView = UIImageView(image: ImageLiterals.imgGuideBox)
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .font(.regular, ofSize: 14)
        label.contentMode = .center
        return label
    }()

    // MARK: - property

    private let type: GuideType

    // MARK: - init

    init(type: GuideType) {
        self.type = type
        super.init(frame: .zero)
        self.setupGuideAction()
        self.configureUI(with: type)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func

    private func setupGuideAction() {
        let guideAction = UIAction { [weak self] _ in
            self?.guideBoxImageView.isHidden.toggle()
        }
        self.guideButton.addAction(guideAction, for: .touchUpInside)
    }

    private func configureUI(with type: GuideType) {
        self.guideButton.setImage(type.image, for: .normal)
        self.guideBoxImageView.isHidden = true
        self.configureGuideContent(to: type.text)
    }

    private func configureGuideContent(to text: String) {
        self.guideLabel.text = text
        self.guideLabel.addLabelSpacing()
        self.guideLabel.textAlignment = .center
        self.applyColorToTargetContent(text)
    }

    private func applyColorToTargetContent(_ content: String) {
        guard let targetTitle = content.split(separator: "\n").map({ String($0) }).first else { return }
        self.guideLabel.applyColor(to: targetTitle, with: .subOrange)
    }

    private func setupGuideButtonLayout() {
        self.addSubview(self.guideButton)
        self.guideButton.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.trailing.equalTo(self.snp.trailing)
            $0.width.height.equalTo(44)
        }
    }

    private func setupGuideButtonLayoutInNavigationBar() {
        self.guideButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
    }

    private func setupGuideBoxLayout(in navigationController: UINavigationController) {
        if let navigationView = navigationController.view {
            navigationView.addSubview(self.guideBoxImageView)
            self.guideBoxImageView.snp.makeConstraints {
                $0.top.equalTo(navigationView.safeAreaLayoutGuide.snp.top).inset(35)
                $0.trailing.equalTo(navigationView.snp.trailing).inset(Size.leadingTrailingPadding + 8)
                $0.width.equalTo(270)
                $0.height.equalTo(90)
            }
        }
    }

    private func setupGuideBoxLayout() {
        self.addSubview(self.guideBoxImageView)
        self.guideBoxImageView.snp.makeConstraints {
            $0.top.equalTo(self.guideButton.snp.bottom).offset(-10)
            $0.trailing.equalTo(self.guideButton.snp.trailing).offset(-12)
            $0.width.equalTo(270)
            $0.height.equalTo(90)
        }

        self.guideBoxImageView.addSubview(self.guideLabel)
        self.guideLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
    }

    func setupDisappearedConfiguration() {
        self.guideBoxImageView.isHidden = true
    }

    func addGuideViewToNavigationController(_ navigationController: UINavigationController) {
        self.setupGuideButtonLayoutInNavigationBar()
        self.setupGuideBoxLayout(in: navigationController)

        let guideButton = UIBarButtonItem(customView: self.guideButton)
        navigationController.navigationItem.rightBarButtonItem = guideButton
    }

    func hideGuideView(in navigationController: UINavigationController, _ viewController: UIViewController) {
        let navigationControllerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissGuideView))
        let viewControllerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissGuideView))
        navigationControllerTapGesture.cancelsTouchesInView = false
        viewControllerTapGesture.cancelsTouchesInView = false
        navigationController.view.addGestureRecognizer(navigationControllerTapGesture)
        viewController.view.addGestureRecognizer(viewControllerTapGesture)
    }

    // MARK: - selector

    @objc
    private func dismissGuideView() {
        if !self.guideButton.isTouchInside {
            self.setupDisappearedConfiguration()
        }
    }
}
