//
//  SceneDelegate.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let usecase = SplashUsecaseImpl()
        let viewModel = SplashViewModel(usecase: usecase)
        window.rootViewController = SplashViewController(viewModel: viewModel)
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

extension SceneDelegate {
    func moveToLoginViewController() {
        let repository = LoginRepositoryImpl()
        let service = LoginService(repository: repository)
        let viewModel = LoginViewModel(loginService: service)
        let viewController = LoginViewController(viewModel: viewModel)
        window?.rootViewController = viewController
    }
    
    func changeRootViewWithLetterView(roomId: Int) {
        let mainViewController = MainViewController()
        let rootViewController = UINavigationController(rootViewController: mainViewController)
        window?.rootViewController = rootViewController
        mainViewController.pushDetailViewController(roomId: roomId)
    }
    
    func showRoomIdErrorAlert() {
        let mainViewController = MainViewController()
        mainViewController.showRoomIdErrorAlert()
    }
}
