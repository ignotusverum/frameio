//
//  Team.swift
//  FrameIOFoundation
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Team: Decodable {
    public var id: String
    public var type: String
    public var name: String?
    
    public var projects: [Project] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        
        case attributes
        
        enum AttributesCodingKeys: String, CodingKey {
            case name
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        
        if let attributes = try? container.nestedContainer(keyedBy: CodingKeys.AttributesCodingKeys.self, forKey: .attributes) {
            name = try attributes.decode(String.self, forKey: .name)
        }
    }
}
