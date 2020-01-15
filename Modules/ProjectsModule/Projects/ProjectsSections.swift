//
//  ProjectsSections.swift
//  FrameUIKit
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import FrameIOFoundation

public enum ProjectsSections {
    case recent(String, [Project])
    case list(String, [Project])
}
