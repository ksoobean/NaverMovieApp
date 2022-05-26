//
//  SceneDelegate.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        self.window?.rootViewController?.view.removeFromSuperview()
        self.window?.rootViewController = nil
        window?.rootViewController = UINavigationController(rootViewController: SearchMovieListController())
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    /// 앱이 시작될 때
    func sceneDidBecomeActive(_ scene: UIScene) {
        // UserDefault에 즐겨찾기 리스트 빈배열 셋팅
        Database.shared.save(items: [])
    }

    /// 앱이 종료될 때
    func sceneWillResignActive(_ scene: UIScene) {
        // UserDefault에 저장했던 즐겨찾기 리스트 삭제
        Database.shared.removeAll()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

