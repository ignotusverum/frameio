//
//  TabbarControllerRouter.swift
//  frameio
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

class TabBarControllerRouter: Router {
    var viewControllersFactory: ViewControllersFactory?
    
    init(withFactory factory: ViewControllersFactory) {
        viewControllersFactory = factory
    }
    
    lazy var topViewController: UIViewController = {
        let launchSB = UIStoryboard(name: "LaunchScreen", bundle: nil)
        return launchSB.instantiateViewController(withIdentifier: "LaunchScreen")
    }()
    
    let topViewControllerReady = BehaviorRelay(value: false)
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func rootViewController(forLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> UIViewController? {
        let tabbarController = UITabBarController()
        guard let viewControllerFactory = viewControllersFactory else { return tabbarController }
        
        let projectsViewController = viewControllerFactory.viewController(for: PresentableRoutingStep(withStep: .projects(),
                                                                                                      presentationMode: .none))
        
        let projectsNavigationController = UINavigationController(rootViewController: projectsViewController)
        tabbarController.viewControllers = [projectsNavigationController]
        
        return tabbarController
    }
    
    func showLoadingView() {}
    func hideLoadingView() {}
    func handleShortcutItem(_ item: UIApplicationShortcutItem) {}
}

