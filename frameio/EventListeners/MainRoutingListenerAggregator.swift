//
//  MainRoutingListenerAggregator.swift
//  frameio
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

class MainRoutingListenerAggregator: ModuleEventsListenersAggregator {
    var handledRoutingContext: [String]? = ["main", "deeplink"]
    
    let moduleListeners: [AnyModuleEventsListener]
    
    init(withRouter router: Router) {
        moduleListeners = [
            ProjectsRoutingListener(router)
        ]
    }
}

