//
//  RecipeModel.swift
//  sousChef
//
//  Created by Raymond Kim on 10/6/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import Foundation

class RecipeModel {
    
    var imageURL: String?
    var title: String
    var duration: String
    var ingredients: [IngredientModel]
    
    init(imageURL: String?, title: String, duration: String, ingredients: [IngredientModel]) {
        self.imageURL = ""
        self.title = "Char Siu Pork"
        self.duration = duration
        self.ingredients = ingredients
    }
}
