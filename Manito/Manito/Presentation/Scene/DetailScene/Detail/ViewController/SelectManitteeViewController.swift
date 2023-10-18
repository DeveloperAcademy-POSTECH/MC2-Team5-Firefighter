//
//  SelectManitteeViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/19.
//

import Combine
import UIKit

final class SelectManitteeViewController: UIViewController, Navigationable {

    // MARK: - ui component

    private let selectManitteeView: SelectManitteeView = SelectManitteeView()

    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()
    
    private let viewModel: any BaseViewModelType

    // MARK: - init

    init(viewModel: any BaseViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        self.bindViewModel()
        self.setupNavigation()
    }

    // MARK: - func
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }

    private func transformedOutput() -> SelectManitteeViewModel.Output? {
        guard let viewModel = self.viewModel as? SelectManitteeViewModel else { return nil }
        let input = SelectManitteeViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            swapView: self.selectManitteeView.nextStepSubject.eraseToAnyPublisher(),
            confirmButtonDidTap: self.selectManitteeView.confirmButtonPublisher
        )
        return viewModel.transform(from: input)
    }

    private func bindOutputToViewModel(_ output: SelectManitteeViewModel.Output?) {
        guard let output = output else { return }
        
        output.currentType
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] type in
                switch type {
                case (.showJoystick, _): 
                    self?.selectManitteeView.showJoystick()
                case (.showCapsule, _): 
                    self?.selectManitteeView.showCapsule()
                case (.openName, let nickname): 
                    self?.selectManitteeView.setupManitteeNickname(nickname)
                    self?.selectManitteeView.showManitteeName()
                case (.openButton, _):
                    self?.selectManitteeView.showConfirmButton()
                }
            })
            .store(in: &self.cancelBag)
        
        output.roomId
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.presentDetailIngViewController(roomId: $0)
            })
            .store(in: &self.cancelBag)
    }
}

// MARK: - Helper
extension SelectManitteeViewController {
    private func presentDetailIngViewController(roomId: String) {
        guard let presentingViewController = self.presentingViewController as? UINavigationController else { return }
        let detailingViewController = DetailingViewController(roomId: roomId)
        presentingViewController.popViewController(animated: true)
        presentingViewController.pushViewController(detailingViewController, animated: false)
        self.dismiss(animated: true)
    }
}
