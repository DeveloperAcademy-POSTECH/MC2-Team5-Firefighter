//
//  SendLetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/23.
//

import Combine
import UIKit

protocol SendLetterViewControllerDelegate: AnyObject {
    func refreshLetterData()
}

final class SendLetterViewController: UIViewController, Navigationable, Keyboardable {

    typealias AlertAction = ((UIAlertAction) -> Void)?

    // MARK: - ui component

    private let sendLetterView: SendLetterView = SendLetterView()

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()

    private let viewModel: any BaseViewModelType

    private weak var delegate: SendLetterViewControllerDelegate?

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
        self.view = self.sendLetterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupKeyboardGesture()
        self.configureDelegation()
        self.configureNavigationController()
        self.bindUI()
        self.bindViewModel()
    }

    // MARK: - func

    private func configureDelegation() {
        self.navigationController?.presentationController?.delegate = self
    }

    private func configureNavigationController() {
        self.sendLetterView.configureNavigationController(of: self)
    }

    // MARK: - func - bind

    private func bindUI() {
        self.sendLetterView.cancelButtonTapPublisher
            .sink(receiveValue: { [weak self] hasChanged in
                if hasChanged {
                    self?.showDiscardChangesActionSheet()
                } else {
                    self?.presentationControllerDidDismiss()
                }
            })
            .store(in: &self.cancelBag)
    }

    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }

    private func transformedOutput() -> SendLetterViewModel.Output? {
        guard let viewModel = self.viewModel as? SendLetterViewModel else { return nil }
        let input = SendLetterViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            sendLetterButtonDidTap: self.sendLetterView.sendButtonTapPublisher
                .handleEvents(receiveOutput: { [weak self] _ in
                    self?.sendLetterView.updateSendButtonIsEnabled(to: false)
                })
                .map { [weak self] (content, image) in
                    let data = self?.convertToData(image: image)
                    return (content, data)
                }
                .eraseToAnyPublisher()
        )

        return viewModel.transform(from: input)
    }

    private func bindOutputToViewModel(_ output: SendLetterViewModel.Output?) {
        guard let output = output else { return }

        output.mission
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] mission in
                self?.sendLetterView.setupMission(to: mission)
            })
            .store(in: &self.cancelBag)

        output.letterResponse
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.handleRefreshLetter()
                case .failure(let error):
                    self?.sendLetterView.updateSendButtonIsEnabled(to: true)
                    self?.showErrorAlert(error.localizedDescription)
                }
            })
            .store(in: &self.cancelBag)
    }
}

// MARK: - Helper
extension SendLetterViewController {
    private func showDiscardChangesActionSheet() {
        let dismissAction: AlertAction = { [weak self] _ in
            self?.resignFirstResponder()
            self?.dismiss(animated: true)
        }
        self.makeActionSheet(actionTitles: [TextLiteral.destructive, TextLiteral.cancel],
                             actionStyle: [.destructive, .cancel],
                             actions: [dismissAction, nil])
    }

    private func presentationControllerDidDismiss() {
        self.dismiss(animated: true)
    }

    private func convertToData(image: UIImage?) -> Data? {
        return image?.jpegData(compressionQuality: 0.3)
    }

    private func showErrorAlert(_ message: String) {
        self.makeAlert(title: TextLiteral.letterViewControllerErrorTitle,
                       message: message)
    }

    private func handleRefreshLetter() {
        self.delegate?.refreshLetterData()
        self.dismiss(animated: true)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension SendLetterViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.presentationControllerDidDismiss()
    }
}
