//
//  RecipeOverviewViewModel.swift
//  sousChef
//
//  Created by Raymond Kim on 10/5/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

protocol RecipeOverviewViewModel {
    var recipes: [RecipeDetailViewModelWithRecipe] { get }
}

class RecipeOverviewViewModelWithRecipes: NSObject, RecipeOverviewViewModel {
    
    var recipes: [RecipeDetailViewModelWithRecipe]
    
    init(_ recipes: [RecipeDetailViewModelWithRecipe]) {
        self.recipes = recipes
        
        // network call to get recipe data
    }

}
