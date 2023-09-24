//
//  SendLetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/23.
//

import UIKit

final class SendLetterViewController: UIViewController, Navigationable, Keyboardable {

    // MARK: - ui component

    private let sendLetterView: CreateLetterView = CreateLetterView()

    // MARK: - property

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
        self.view = self.sendLetterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureDelegation()
        self.configureNavigationController()
        self.setupNavigation()
        self.setupKeyboardGesture()
    }

    // MARK: - func

    private func configureUI() {
        self.createLetterView.configureMission(self.mission)
        self.createLetterView.configureViewController(self)
    }

    private func configureDelegation() {
        self.createLetterView.configureDelegation(self)
    }

    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        self.createLetterView.configureNavigationController(navigationController)
        self.createLetterView.configureNavigationBar(navigationController)
        self.createLetterView.configureNavigationItem(navigationController)
    }

    func configureDelegation(_ delegate: CreateLetterViewControllerDelegate) {
        self.delegate = delegate
    }

    func presentationControllerDidDismiss() {
        self.dismiss(animated: true)
    }

    func showActionSheet() {
        let dismissAction: AlertAction = { [weak self] _ in
            self?.resignFirstResponder()
            self?.dismiss(animated: true)
        }
        self.makeActionSheet(actionTitles: [TextLiteral.destructive, TextLiteral.cancel],
                             actionStyle: [.destructive, .cancel],
                             actions: [dismissAction, nil])
    }

    func sendLetterToManittee(with content: String?, _ image: UIImage?) {
        let jpegData = image?.jpegData(compressionQuality: 0.3)
        let letterDTO = LetterRequestDTO(manitteeId: self.manitteeId, messageContent: content)

        self.createLetterView.sending = true
        self.dispatchLetter(with: letterDTO, jpegData) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success:
                    self?.delegate?.refreshLetterData()
                    self?.dismiss(animated: true)
                case .failure:
                    self?.createLetterView.sending = false
                    self?.makeAlert(title: TextLiteral.createLetterViewControllerErrorTitle,
                                    message: TextLiteral.createLetterViewControllerErrorMessage)
                }
            }
        }
    }
}
