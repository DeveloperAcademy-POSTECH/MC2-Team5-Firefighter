//
//  CreateLetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import UIKit

final class CreateLetterViewController: BaseViewController {

    typealias AlertAction = ((UIAlertAction) -> ())

    // MARK: - ui component

    private let createLetterView: CreateLetterView = CreateLetterView()
    
    // MARK: - property

    private let letterSevice: LetterAPI = LetterAPI(apiService: APIService())
    private let mission: String
    private let manitteeId: String
    private let roomId: String
    var missionId: String

    var succeedInSendingLetter: (() -> Void)?

    // MARK: - init
    
    init(manitteeId: String, roomId: String, mission: String, missionId: String) {
        self.manitteeId = manitteeId
        self.roomId = roomId
        self.mission = mission
        self.missionId = missionId
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

    private func dispatchLetter(with letterDTO: LetterDTO,
                                _ jpegData: Data? = nil,
                                completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let statusCode = try await self.letterSevice.dispatchLetter(roomId: self.roomId, image: jpegData, letter: letterDTO, missionId: self.missionId)
                switch statusCode {
                case 200..<300: completionHandler(.success(()))
                default: completionHandler(.failure(.unknownError))
                }
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
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
        let jpegData = image?.jpegData(compressionQuality: 0.3)
        let letterDTO = LetterDTO(manitteeId: self.manitteeId, messageContent: content)

        self.createLetterView.sending = true
        self.dispatchLetter(with: letterDTO, jpegData) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success:
                    self?.succeedInSendingLetter?()
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
