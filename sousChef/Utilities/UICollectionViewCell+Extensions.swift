//
//  UICollectionViewCell+Extensions.swift
//  sousChef
//
//  Created by Raymond Kim on 10/5/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    class var identifier: String {
        return String(describing: self)
    }
}
