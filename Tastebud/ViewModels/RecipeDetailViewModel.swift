//
//  RecipeDetailViewModel.swift
//  Tastebud
//
//  Created by Raymond Kim on 10/6/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

protocol RecipeDetailViewModel {
    var title: String { get }
    var duration: String { get }
    var ingredients: [IngredientModel] { get }
}

class RecipeDetailViewModelWithRecipe: NSObject, RecipeDetailViewModel {
    
    var title: String
    var duration: String
    var ingredients: [IngredientModel]
    
    init(_ recipe: RecipeModel) {
        self.title = recipe.title
        self.duration = recipe.duration
        self.ingredients = recipe.ingredients
    }
}
