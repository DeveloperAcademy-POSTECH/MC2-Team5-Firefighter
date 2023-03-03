//
//  CreateLetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import UIKit

import SnapKit

final class CreateLetterViewController: BaseViewController {

    typealias AlertAction = ((UIAlertAction) -> ())

    // MARK: - ui component

    private let createLetterView: CreateLetterView = CreateLetterView()
    
    // MARK: - property

    private let letterSevice: LetterAPI = LetterAPI(apiService: APIService())
    private let viewModel: CreateLetterViewModel
    private let mission: String
    private let manitteeId: String
    private let roomId: String

    var createLetter: (() -> Void)?

    // MARK: - init
    
    init(manitteeId: String, roomId: String, mission: String) {
        self.manitteeId = manitteeId
        self.roomId = roomId
        self.mission = mission
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    override func loadView() {
        self.view = self.createLetterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
        self.configureNavigationController()
    }

    // MARK: - override

    override func configureUI() {
        super.configureUI()
        self.createLetterView.configureMission(self.mission)
        self.createLetterView.configureViewController(self)
    }

    // MARK: - func

    private func configureDelegation() {
        self.createLetterView.configureDelegation(self)
    }

    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        self.createLetterView.configureNavigationController(navigationController)
        self.createLetterView.configureNavigationBar(navigationController)
        self.createLetterView.configureNavigationItem(navigationController)
    }
    
    // MARK: - network

    private func dispatchLetter(with content: String? = nil, _ image: UIImage? = nil) {
        Task {
            do {
                let jpegData = image?.jpegData(compressionQuality: 0.3)
                let letterDTO = LetterDTO(manitteeId: self.manitteeId, messageContent: content)

                let status = try await self.letterSevice.dispatchLetter(roomId: self.roomId, image: jpegData, letter: letterDTO)

                if status == 201 {
                    self.createLetter?()
                }
            } catch NetworkError.serverError {
                print("serverError")
            } catch NetworkError.clientError(let message) {
                print("clientError:\(String(describing: message))")
            }
        }
    }
}

// MARK: - CreateLetterViewDelegate
extension CreateLetterViewController: CreateLetterViewDelegate {
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
        self.dispatchLetter(with: <#T##String?#>)
        self.dismiss(animated: true)
    }
}
