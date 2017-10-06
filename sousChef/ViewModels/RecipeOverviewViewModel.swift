//
//  RecipeOverviewViewModel.swift
//  sousChef
//
//  Created by Raymond Kim on 10/5/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

protocol RecipeOverviewViewModel {
    var recipes: [RecipeModel] { get }
}

class RecipeOverviewViewModelWithRecipes: NSObject, RecipeOverviewViewModel {
    
    var recipes: [RecipeModel]
    
    init(_ recipes: [RecipeModel]) {
        self.recipes = recipes
        
        // network call to get recipe data
    }

}
