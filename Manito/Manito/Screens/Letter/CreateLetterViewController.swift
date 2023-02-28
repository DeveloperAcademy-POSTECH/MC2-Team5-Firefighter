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
    
    // MARK: - property

    var createLetter: (() -> ())?
    
    private let letterSevice: LetterAPI = LetterAPI(apiService: APIService())
    var manitteeId: String
    var roomId: String
    var mission: String
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - func

    private func configureDelegate() {
        
    }

    private func configureNavigationController() {
        // view.configureNavigationBar 연결
        self.navigationController?.presentationController?.delegate = self
        self.isModalInPresentation = true
        self.title = TextLiteral.createLetterViewControllerTitle
    }


    
    // MARK: - network
    
    private func dispatchLetter(roomId: String) {
        Task {
            do {
                if let content = self.letterTextView.text,
                   let image = self.letterPhotoView.image,
                   image != ImageLiterals.btnCamera {
                    guard let jpegData = image.jpegData(compressionQuality: 0.3) else { return }
                    let dto = LetterDTO(manitteeId: self.manitteeId, messageContent: content)
                    
                    let status = try await self.letterSevice.dispatchLetter(roomId: roomId, image: jpegData, letter: dto)

                    if status == 201 {
                        self.createLetter?()
                    }
                } else if let content = self.letterTextView.text {
                    let dto = LetterDTO(manitteeId: self.manitteeId, messageContent: content)
                    
                    let status = try await self.letterSevice.dispatchLetter(roomId: roomId, letter: dto)

                    if status == 201 {
                        self.createLetter?()
                    }
                } else if let image = self.letterPhotoView.image,
                          image != ImageLiterals.btnCamera {
                    guard let jpegData = image.jpegData(compressionQuality: 0.3) else { return }
                    let dto = LetterDTO(manitteeId: self.manitteeId)

                    let status = try await self.letterSevice.dispatchLetter(roomId: roomId, image: jpegData, letter: dto)
                    
                    if status == 201 {
                        self.createLetter?()
                    }
                }
                
            } catch NetworkError.serverError {
                print("serverError")
            } catch NetworkError.clientError(let message) {
                print("clientError:\(String(describing: message))")
            }
        }
    }
}

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
}
