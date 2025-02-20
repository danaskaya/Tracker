//
//  TapBarController.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 10.02.2025.
//

import UIKit
class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setBorder()
    }
    private func setupTabBar() {
        let vc = UINavigationController(rootViewController: TrackersViewController())
        vc.tabBarItem.title = "Трекеры"
        vc.tabBarItem.image = UIImage(named: "trackerImage")
        let statisticVC = setupVC(vc: StatisticViewController(), title: "Статистика", image: UIImage(named: "statisticImage"))
        viewControllers = [vc, statisticVC]
    }
    private func setupVC(vc: UIViewController, title: String, image: UIImage?) -> UIViewController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }
    private func setBorder() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1)
        topBorder.backgroundColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
        tabBar.layer.addSublayer(topBorder)
    }
}
