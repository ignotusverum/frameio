//
//  APIDecodable.swift
//  FrameIOFoundation
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public protocol JapxDecodable: Decodable {
    var type: String { get }
    var id: String { get }
}
