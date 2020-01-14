//
//  EntitiesUtil.swift
//  FrameIOFoundation
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait, Element == Data {
    func decode<T: Decodable>(decoder: JSONDecoder? = nil) -> Single<T> {
        let defaultDecoder = JSONDecoder()
        defaultDecoder.dateDecodingStrategy = .formatted(.iso8601Full)
        
        return map {
            try (decoder ?? defaultDecoder)
                .decode(T.self, from: $0)
        }
    }
}
