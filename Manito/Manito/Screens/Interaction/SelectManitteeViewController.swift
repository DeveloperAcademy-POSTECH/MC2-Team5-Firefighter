//
//  SelectManitteeViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/19.
//

import UIKit

final class SelectManitteeViewController: BaseViewController {

    private enum SelectionStep: Int {
        case showJoystick = 0, showCapsule, openName, openButton
    }

    // MARK: - ui component

    private let selectManitteeView: SelectManitteeView = SelectManitteeView()

    // MARK: - property

    private let roomId: String
    private var stepType: SelectionStep? {
        willSet(step) {
            guard let stepIndex = step?.rawValue else { return }
            self.selectManitteeView.manageStepView(step: stepIndex)
        }
    }

    // MARK: - init

    init(roomId: String, manitteeNickname: String) {
        self.roomId = roomId
        super.init()
        self.selectManitteeView.configureUI(manitteeNickname: manitteeNickname)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    override func loadView() {
        self.view = self.selectManitteeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
    }

    // MARK: - override

    override func configureUI() {
        super.configureUI()
        self.stepType = .showJoystick
    }

    // MARK: - func

    private func configureDelegation() {
        self.selectManitteeView.configureDelegation(self)
    }
}

// MARK: - SelectManitteeViewDelegate
extension SelectManitteeViewController: SelectManitteeViewDelegate {
    func confirmButtonDidTap() {
        guard let presentingViewController = self.presentingViewController as? UINavigationController else { return }
        let detailingViewController = DetailingViewController(roomId: self.roomId)
        presentingViewController.popViewController(animated: true)
        presentingViewController.pushViewController(detailingViewController, animated: false)
        self.dismiss(animated: true)
    }

    func moveToNextStep() {
        guard let stepIndex = self.stepType?.rawValue,
              let nextStep = SelectionStep(rawValue: stepIndex + 1) else { return }
        self.stepType = nextStep
    }
}
