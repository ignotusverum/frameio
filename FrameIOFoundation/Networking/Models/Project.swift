//
//  Project.swift
//  FrameIOFoundation
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Project: Decodable, Equatable {
    public var id: String
    public var type: String?
    public var name: String
    public var updatedAt: Date?
    
    public var teams: Team?
    
    enum CodingKeys: String, CodingKey {
        case attributes
        case relationships
        
        case id
        case type
        
        enum AttributesCodingKeys: String, CodingKey {
            case name
            case updatedAt = "updated_at"
        }
        
        enum RelationshopsCodingKeys: String, CodingKey {
            case team
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        
        let attributes = try container.nestedContainer(keyedBy: CodingKeys.AttributesCodingKeys.self, forKey: .attributes)
        let relationships = try container.nestedContainer(keyedBy: CodingKeys.RelationshopsCodingKeys.self, forKey: .relationships)
        
        name = try attributes.decode(String.self, forKey: .name)
        updatedAt = try attributes.decode(Date.self, forKey: .updatedAt)
        
        teams = try relationships.decode(Team.self, forKey: .team)
    }
    
    public static func == (lhs: Project, rhs: Project) -> Bool { lhs.id == rhs.id }
}
