//
//  ProjectsModule.swift
//  ProjectsModule
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import FrameIOFoundation

public class ProjectsModuleContext: ModuleContextProtocol {
    public typealias ModuleType = ProjectsModule
    
    public var routingContext: String
    
    public init(routingContext: String) {
        self.routingContext = routingContext
    }
    
    public func make() -> (AnyModule, UIViewController) {
        let module = ModuleType(usingContext: self)
        return (module, module.prepareRootViewController())
    }
}

public enum ProjectsModuleEvents: EventProtocol {
    case projectSelected(Project)
}

public class ProjectsModule: NSObject, ModuleProtocol, EventsProducer {
    public var events: Observable<ProjectsModuleEvents> { return _events.asObservable() }
    private var _events = PublishSubject<ProjectsModuleEvents>()
    
    public var context: ProjectsModuleContext
    
    public required init(usingContext buildContext: ProjectsModuleContext) {
        context = buildContext
    }
    
    public func unmanagedRootViewController() -> UIViewController {
        return UIViewController()
    }
}

