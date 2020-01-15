//
//  ProjectsRoutingListener.swift
//  frameio
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

class ProjectsRoutingListener: ModuleEventsListener {
    var router: Router
    init(_ router: Router) {
        self.router = router
    }
    
    func listenEvents(from module: AnyEventsProducerModule,
                      events: Observable<ProjectsEvents>) -> Bool {
        return true
    }
}
