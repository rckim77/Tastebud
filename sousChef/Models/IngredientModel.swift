//
//  IngredientModel.swift
//  sousChef
//
//  Created by Raymond Kim on 10/6/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import Foundation

class IngredientModel {
    var title: String
    var measurement: String
    
    init(title: String, measurement: String) {
        self.title = title
        self.measurement = measurement
    }
}
