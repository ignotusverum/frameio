//
//  AppRouter.swift
//  frameio
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import ProjectsModule
import MERLin
import Foundation

typealias ProjectsEvents = ProjectsModuleEvents

extension ModuleRoutingStep {
    static func projects() -> ModuleRoutingStep {
        let context = ProjectsModuleContext(routingContext: "main")
        return ModuleRoutingStep(withMaker: context)
    }
}

