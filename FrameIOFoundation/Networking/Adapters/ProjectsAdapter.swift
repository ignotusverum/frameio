//
//  ProjectsAdapter.swift
//  FrameIOFoundation
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

import RxSwift

public protocol ProjectsNetworkingProtocol where Self: NetworkingAdapter {
    static func fetchProjects()-> Single<ProjectsContainer>
}

public class ProjectsAdapter: NetworkingAdapter {
    public var settings: AdapterConfig!
    private static var adapter: ProjectsAdapter!
    
    @discardableResult
    public init(config: AdapterConfig) {
        settings = config
        ProjectsAdapter.adapter = self
    }
}

extension ProjectsAdapter: ProjectsNetworkingProtocol {
    public static func fetchProjects() -> Single<ProjectsContainer> {
        let config = Requests
            .fetchProjects
            .configure
        
        return adapter
            .request(config)
            .decode()
    }
}

private extension ProjectsAdapter {
    enum Requests: FrameAPIRequest {
        case fetchProjects
        
        public var configure: RequestConfig {
            switch self {
            case .fetchProjects:
                return RequestConfig(method: .get,
                                     queryItems: [
                                        URLQueryItem(name: "include",
                                                     value: "team")
                ])
            }
        }
    }
}
