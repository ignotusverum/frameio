//
//  ProjectsAPIConfigurable.swift
//  FrameIOFoundation
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

public protocol ProjectsAPIConfigurable where Self: MainAPIConfigurable {}

public extension ProjectsAPIConfigurable {
    static var apiConfig: APIConfig { MainAPIConfig.projects.config() }
}
