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
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: SplashViewController.className) as? SplashViewController else { return }
        
        window.rootViewController = viewController
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
    func logout() {
        window?.rootViewController = LoginViewController()
    }
    
    func changeRootViewWithMessageView(roomId: Int) {
        let viewController = UINavigationController(rootViewController: MainViewController())
        let storyboard = UIStoryboard(name: "DetailIng", bundle: nil)
        guard let detailIngviewController = storyboard.instantiateViewController(withIdentifier: DetailIngViewController.className) as? DetailIngViewController else { return }
        let roomInfo = ParticipatingRoom(id: roomId,
                                         title: nil,
                                         participatingCount: nil,
                                         capacity: nil,
                                         startDate: nil,
                                         endDate: nil)
        detailIngviewController.roomInformation = roomInfo
        viewController.pushViewController(detailIngviewController, animated: true)
        window?.rootViewController = viewController
    }
}
