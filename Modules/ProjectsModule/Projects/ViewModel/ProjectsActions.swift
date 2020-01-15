//
//  ProjectsActions.swift
//  ProjectsModule
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import FrameIOFoundation

enum ProjectsUIAction: EventProtocol {
    case itemSelected(Project)
}

enum ProjectsModelAction: EventProtocol {
    case sectionsChanged(sections: [Project])
}

enum ProjectsActions: EventProtocol {
    case ui(ProjectsUIAction)
    case model(ProjectsModelAction)
}
