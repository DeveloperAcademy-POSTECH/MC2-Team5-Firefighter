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
            case .letter: return TextLiteral.Letter.guide.localized()
            case .main: return TextLiteral.Main.guide.localized()
            case .detailing: return TextLiteral.DetailIng.guide.localized()
            }
        }

        var image: UIImage {
            switch self {
            case .letter: return ImageLiterals.icLetterMissionInfo
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

    // MARK: - init

    init(type: GuideType) {
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

    func setupGuideViewLayout() {
        self.addSubview(self.guideButton)
        self.guideButton.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.trailing.equalTo(self.snp.trailing)
            $0.width.height.equalTo(44)
        }

        self.addSubview(self.guideBoxImageView)
        self.guideBoxImageView.snp.makeConstraints {
            $0.top.equalTo(self.guideButton.snp.bottom).offset(-10)
            $0.trailing.equalTo(self.guideButton.snp.trailing).offset(-12)
            $0.leading.bottom.equalToSuperview()
            $0.width.equalTo(270)
            $0.height.equalTo(90)
        }

        self.guideBoxImageView.addSubview(self.guideLabel)
        self.guideLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
    }

    func setupGuideViewLayout(in navigationController: UINavigationController) {
        if let view = navigationController.view {
            self.guideButton.snp.makeConstraints {
                $0.width.height.equalTo(44)
            }

            view.addSubview(self.guideBoxImageView)
            self.guideBoxImageView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(35)
                $0.trailing.equalTo(view.snp.trailing).inset(SizeLiteral.leadingTrailingPadding + 8)
                $0.width.equalTo(270)
                $0.height.equalTo(90)
            }

            self.guideBoxImageView.addSubview(self.guideLabel)
            self.guideLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(20)
                $0.leading.trailing.equalToSuperview()
            }
        }
    }

    func addGuideButton(in navigationItem: UINavigationItem) {
        let guideButton = UIBarButtonItem(customView: self.guideButton)
        navigationItem.rightBarButtonItem = guideButton
    }

    func hideGuideViewWhenTappedAround(in navigationController: UINavigationController, _ viewController: UIViewController) {
        let navigationControllerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapAroundToHideGuideView))
        let viewControllerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapAroundToHideGuideView))
        navigationControllerTapGesture.cancelsTouchesInView = false
        viewControllerTapGesture.cancelsTouchesInView = false
        navigationController.view.addGestureRecognizer(navigationControllerTapGesture)
        viewController.view.addGestureRecognizer(viewControllerTapGesture)
    }

    func removeGuideView() {
        self.guideBoxImageView.removeFromSuperview()
    }

    func hideGuideView() {
        self.guideBoxImageView.isHidden = true
    }

    // MARK: - selector

    @objc
    func didTapAroundToHideGuideView() {
        if !self.guideButton.isTouchInside {
            self.hideGuideView()
        }
    }
}
