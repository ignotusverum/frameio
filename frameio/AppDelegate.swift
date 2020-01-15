//
//  AppDelegate.swift
//  frameio
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit
import FrameIOFoundation
import RxSwift
import MERLin

@UIApplicationMain
class AppDelegate:
    UIResponder,
    EventsProducer,
    UIApplicationDelegate {
    let disposeBag = DisposeBag()
    var router: TabBarControllerRouter!
    var moduleManager: BaseModuleManager!
    
    var window: UIWindow?
    
    var events: Observable<AppDelegateEvent> { return _events }
    private let _events = PublishSubject<AppDelegateEvent>()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        /// Modules + Router
        moduleManager = BaseModuleManager()
        router = TabBarControllerRouter(withFactory: moduleManager)
        
        let eventsListeners: [AnyEventsListener] = [
            MainRoutingListenerAggregator(withRouter: router),
            AppDelegateRoutingEventsListener(withRouter: router)
        ]
        
        moduleManager.addEventsListeners(eventsListeners)
        eventsListeners.forEach { $0.listenEvents(from: self) }
        
        /// Configure networking adapters
        ProjectsAdapter.configurator()
        
        _events.onNext(.willFinishLaunching(application: application,
                                            launchOptions: launchOptions))
        
        return true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

