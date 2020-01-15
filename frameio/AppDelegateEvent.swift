//
//  AppDelegateEvent.swift
//  frameio
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import RxSwift

enum AppDelegateEvent: EventProtocol {
    // app start
    case willFinishLaunching(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
}
