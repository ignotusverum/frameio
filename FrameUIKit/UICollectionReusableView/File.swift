//
//  File.swift
//  FrameUIKit
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class CollectionHeaderView: UICollectionReusableView {
    public var titleAlignment: NSTextAlignment = .left {
        didSet {
            titleLabel.textAlignment = titleAlignment
        }
    }
    
    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var titleLabel: UILabel = { UILabel() }()
    
    private let sectionOffset: CGFloat = 10
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        titleLabel.text = title
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                            constant: sectionOffset),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                               constant: -sectionOffset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: sectionOffset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -sectionOffset)
        ])
    }
}

