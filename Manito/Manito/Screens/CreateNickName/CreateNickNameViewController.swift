//
//  CreateNickNameViewController.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/12.
//

import UIKit

import SnapKit

class CreateNickNameViewController: BaseViewController {
    
    private let settingRepository: SettingRepository = SettingRepositoryImpl()
    private lazy var nicknameView: NicknameView = NicknameView(title: TextLiteral.createNickNameViewControllerTitle)
    
    // MARK: - property
    
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life Cycle
    
    override func loadView() {
        self.view = self.nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - API - 옮길예정
    func requestNickname(nickname: NicknameDTO) {
        Task {
            do {
                let data = try await self.settingRepository.putUserInfo(nickname: nickname)
                UserDefaultHandler.setNickname(nickname: data.nickname)
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(message)")
            }
        }
    }
    
    // MARK: - override
    
    override func configureUI() {
        super.configureUI()
    }
    
//    @objc private func didTapDoneButton() {
//        if let text = roomsNameTextField.text, !text.isEmpty {
//            nickname = text
//            UserData.setValue(nickname, forKey: .nickname)
//            UserDefaultHandler.setIsSetFcmToken(isSetFcmToken: true)
//            requestNickname(nickname: NicknameDTO(nickname: nickname))
//            presentMainViewController()
//        }
//    }
    
    private func presentMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }
    
    override func endEditingView() {
        self.nicknameView.endEditingView()
    }
    
    // MARK: - func
    
}
