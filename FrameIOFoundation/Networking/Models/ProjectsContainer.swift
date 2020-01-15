//
//  ProjectsContainer.swift
//  FrameIOFoundation
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct ProjectsContainer: Decodable {
    public var projects: [Project]
    public var teams: [Team]
    
    enum CodingKeys: String, CodingKey {
        case data
        
        case included
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        projects = try container.decode([Project].self,
                                        forKey: .data)
        
        teams = (try? container.decode([Team].self, forKey: .included)) ?? []
    }
}
