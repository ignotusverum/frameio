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
    case sections([ProjectsSection])
    
    indirect case loading(whileInState: ProjectsState?)
    
    static func reduce(_ state: ProjectsState,
                       action: ProjectsUIAction) -> ProjectsState {
        switch (state, action) {
            // Reload
        case let (.loading(aState), .reload):
                return .loading(whileInState: aState)
            case (.sections, .reload):
                return .loading(whileInState: state)
        // Not changing state
        default: return state
        }
    }
    
    static func reduce(_ state: ProjectsState,
                       model: ProjectsModelAction) -> ProjectsState {
        switch (state, model) {
        case (_, .loaded(let newDatasource)):
            let recentSection = recentSectionConfigurator(with: "Recent",
                                                          projects: newDatasource.projects)
            
            let teamSections = teamSectionConfigurator(with: newDatasource.teams,
                                                       projects: newDatasource.projects)
            
            return .sections(([recentSection] + teamSections)
                .compactMap { $0 })
        }
    }

    private static func recentSectionConfigurator(with title: String,
                                                  projects: [Project])-> ProjectsSection? {
        switch projects.count {
        case let count where 1...5 ~= count:
            /// If the user has 5 or fewer projects, the recent sections should be empty
            return .recent(title, [])
        case let count where 5...10 ~= count:
            /// If the user has greater than 5 and fewer than 10, the recent section should contain (n -5) projects, where n is the total number of projects
            let nElementsSlice = projects.prefix(count - 5)
            return .recent(title, Array(nElementsSlice))
        case let count where count > 10:
            /// If the user has greater than 10 projects, the recent section should container 5 projects
            let nElementsSlice = projects.prefix(5)
            return .recent(title, Array(nElementsSlice))
        default: return nil
        }
    }
    
    private static func teamSectionConfigurator(with teams: [Team],
                                         projects: [Project])-> [ProjectsSection] {
        teams.map { team -> ProjectsSection in
            var team = team
            team.projects = projects.filter({$0.team?.id == team.id })
            
            return .list(team,
                         team.projects)
        }
    }
}

extension Array where Element: Equatable {
    func indexes(ofItemsNotEqualTo item: Element) -> [Int]  {
        enumerated().compactMap { $0.element != item ? $0.offset : nil }
    }
}
