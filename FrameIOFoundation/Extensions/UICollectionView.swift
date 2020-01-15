//
//  UICollectionView.swift
//  FrameIOFoundation
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass,
                 forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func registerReusableView<T: UICollectionReusableView>(_ viewClass: T.Type,
                                                           kind: String) {
        register(viewClass,
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, and reuseIdentifier: String = String(describing: T.self)) -> T {
        return dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        withReuseIdentifier reuseIdentifier: String = String(describing: T.self),
        for indexPath: IndexPath
    ) -> T {
        return dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as! T
    }
}
