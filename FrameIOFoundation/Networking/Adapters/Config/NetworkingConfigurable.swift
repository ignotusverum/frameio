//
//  NetworkingConfigurable.swift
//  FrameIOFoundation
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

public protocol NetworkingConfigurable {
    static var baseURL: String { get }
}

public extension MainAPIConfigurable {
    static var baseURL: String { "frameio-swift-exercise.herokuapp.com" }
}
