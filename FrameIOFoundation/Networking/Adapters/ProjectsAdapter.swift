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
    static func fetchProjects()-> Single<[Project]>
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
    public static func fetchProjects() -> Single<[Project]> {
        let config = Requests
            .fetchProjects
            .configure
            
        let adapterRequest: Single<ProjectsContainer> = adapter
            .request(config)
            .decode()
        
        return adapterRequest.map { $0.projects }
    }
}

private extension ProjectsAdapter {
    enum Requests: FrameAPIRequest {
        case fetchProjects
        
        public var configure: RequestConfig {
            switch self {
            case .fetchProjects: return RequestConfig(method: .get)
            }
        }
    }
}
