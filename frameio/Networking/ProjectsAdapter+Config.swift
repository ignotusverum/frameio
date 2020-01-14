//
//  ProjectsAdapter+Config.swift
//  frameio
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import FrameIOFoundation

extension ProjectsAdapter:
    MainAPIConfigurable,
    NetworkingConfigurable,
    ProjectsAPIConfigurable {
    public static func configurator() {
        ProjectsAdapter(config: AdapterConfig(base: baseURL,
                                              name: apiConfig.path))
    }
}
