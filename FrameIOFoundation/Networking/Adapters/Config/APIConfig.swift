//
//  APIConfig.swift
//  FrameIOFoundation
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

public struct APIConfig {
    public var path: String
    public init(path: String) {
        self.path = path
    }
}

enum MainAPIConfig {
    case projects
    
    func config() -> APIConfig {
        switch self {
        case .projects: return APIConfig(path: "projects")
        }
    }
}

public protocol MainAPIConfigurable where Self: NetworkingConfigurable {
    static var apiConfig: APIConfig { get }
}
