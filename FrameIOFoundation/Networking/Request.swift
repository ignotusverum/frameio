//
//  Request.swift
//  FrameIOFoundation
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case trace = "TRACE"
}

public protocol FrameAPIRequest {
    var configure: RequestConfig { get }
}

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

public struct RequestConfig {
    public var method: HTTPMethod
    public var path: String?
    public var parameters: Parameters?
    public var queryItems: [URLQueryItem]?
    
    public init(method: HTTPMethod,
                path: String? = nil,
                parameters: Parameters? = nil,
                queryItems: [URLQueryItem]? = nil) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.queryItems = queryItems
    }
}
