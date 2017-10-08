//
//  RecipeDetailVC.swift
//  sousChef
//
//  Created by Raymond Kim on 5/23/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

class RecipeDetailVC: UIViewController {

    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var ingredientsTitleLabel: UILabel!
    
    @IBAction func startPressed(_ sender: UIButton) {
        
    }
    
    var viewModel: RecipeDetailViewModelWithRecipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        durationLabel.text = "Total: 9 hrs. Active: 1 hr"
        guard let recipe = viewModel else { return }
        
        recipeNameLabel.text = recipe.title
        durationLabel.text = recipe.duration
        ingredientsTitleLabel.text = "Ingredients"
    }

}

// Ingredients collection view
extension RecipeDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.ingredients.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
        
        if let measurement = viewModel?.ingredients[indexPath.row].measurement,
            let title = viewModel?.ingredients[indexPath.row].title {
            cell.ingredientLabel.text = measurement + " " + title
        }
        
        return cell
    }
}
