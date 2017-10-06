//
//  RecipeOverviewVCViewController.swift
//  sousChef
//
//  Created by Raymond Kim on 5/23/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

class RecipeOverviewVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: RecipeOverviewViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ingredients = [IngredientModel(title: "pork shoulder, boneless", measurement: "2kg"),
                           IngredientModel(title: "salt", measurement: "20g"),
                           IngredientModel(title: "char siu sauce (e.g., Lee Kum Kee)", measurement: "230g"),
                           IngredientModel(title: "spicy mustard, for garnish", measurement: "300g"),
                           IngredientModel(title: "green onions, for garnish", measurement: "150g"),
                           IngredientModel(title: "sesame seeds, for garnish", measurement: "75g")]
        
        let recipeDetailViewModel = RecipeDetailViewModelWithRecipe(RecipeModel(imageURL: "", title: "Char Siu Pork", duration: "9 hrs", ingredients: ingredients))
        viewModel = RecipeOverviewViewModelWithRecipes([recipeDetailViewModel])
        
        // bind using RxSwift
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetailVC" {
            let destinationVC = segue.destination as! RecipeDetailVC
            let sender = sender as! RecipeOverviewCell
            if let senderIndex = collectionView.indexPath(for: sender)?.row {
                destinationVC.viewModel = viewModel?.recipes[senderIndex]
            }
        }
    }

}


extension RecipeOverviewVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.recipes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let recipes = viewModel?.recipes, recipes.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeOverviewCell.identifier, for: indexPath) as! RecipeOverviewCell
            
            cell.recipeNameLabel.text = recipes[indexPath.row].title
            
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
}
