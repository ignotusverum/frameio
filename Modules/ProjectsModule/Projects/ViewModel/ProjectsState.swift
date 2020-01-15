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
            switch newSections.count {
            case let count where 1...5 ~= count:
                /// If the user has 5 or fewer projects, the recent sections should be empty
                return .sections([])
            case let count where 5...10 ~= count:
                /// If the user has greater than 5 and fewer than 10, the recent section should contain (n -5) projects, where n is the total number of projects
                let nElementsSlice = newSections.prefix(count - 5)
                return .sections(Array(nElementsSlice))
            case let count where count > 10:
                /// If the user has greater than 10 projects, the recent section should container 5 projects
                let nElementsSlice = newSections.prefix(5)
                return .sections(Array(nElementsSlice))
            default: break
            }
            
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
