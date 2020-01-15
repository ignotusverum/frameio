//
//  ProjectsState.swift
//  ProjectsModule
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import FrameIOFoundation

enum ProjectsState: CaseAccessible, Equatable {
    case sections([Project])
    static func reduce(_ state: ProjectsState,
                       action: ProjectsUIAction) -> ProjectsState {
        switch (state, action) {
        // Not changing state
        case (.sections(_),
              .itemSelected(_)): return state
        }
    }
    
    static func reduce(_ state: ProjectsState,
                       model: ProjectsModelAction) -> ProjectsState {
        switch (state, model) {
        case let (.sections(_),
                  .sectionsChanged(newSections)):
            return .sections(newSections)
        }
    }
    
    static func == (lhs: ProjectsState, rhs: ProjectsState) -> Bool {
        switch (lhs, rhs) {
        case let (.sections(lSections),
                  .sections(rSections)): return lSections.isEqual(rSections)
        }
    }
}

extension Array where Element == Project {
    func isEqual(_ array: [Project]) -> Bool {
        zip(self, array).reduce(count == array.count) { $0 && $1.0 == $1.1 }
    }
}
