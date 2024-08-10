//
//  MainTabViewController.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/10/24.
//

import UIKit

final class MainTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBar()
    }
    
    func setUpTabBar() {
        
        let today = UINavigationController(rootViewController: ViewController())
        today.tabBarItem = UITabBarItem(title: "투데이", image: UIImage(systemName: "doc.text.image"), tag: 0)
        
        let game = UINavigationController(rootViewController: ViewController())
        game.tabBarItem = UITabBarItem(title: "게임", image: UIImage(systemName: "gamecontroller.fill"), tag: 1)
        
        let app = UINavigationController(rootViewController: ViewController())
        app.tabBarItem = UITabBarItem(title: "앱", image: UIImage(systemName: "square.stack.3d.up.fill"), tag: 2)
        
        let arcade = UINavigationController(rootViewController: ViewController())
        arcade.tabBarItem = UITabBarItem(title: "아케이드", image: UIImage(systemName: "star.square"), tag: 3)
        
        let search = UINavigationController(rootViewController: SearchViewController())
        search.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 4)
        
        setViewControllers([today, game, app, arcade, search], animated: true)
        
        selectedViewController = search
    }
    
}
