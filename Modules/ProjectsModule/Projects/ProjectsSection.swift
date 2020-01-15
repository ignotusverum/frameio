//
//  ProjectsSections.swift
//  FrameUIKit
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import FrameIOFoundation

public enum ProjectsSection: Equatable {
    case recent(String, [Project])
    case list(Team, [Project])
    
    public static func == (lhs: ProjectsSection, rhs: ProjectsSection) -> Bool {
        switch (lhs, rhs) {
        case (let .recent(lTitle, lProjects),
              let .recent(rTitle, rProjects)): return lTitle == rTitle && lProjects.isEqual(rProjects)
            
        case (let .list(lTeam, lProjects),
              let .list(rTeam, rProjects)): return lTeam.id == rTeam.id && lProjects.isEqual(rProjects)
        default: return false
        }
    }
}

extension Array where Element == Project {
    func isEqual(_ array: [Project]) -> Bool {
        zip(self, array).reduce(count == array.count) { $0 && $1.0 == $1.1 }
    }
}
