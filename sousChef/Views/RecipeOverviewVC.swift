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
        
        let recipe = RecipeModel(imageURL: "", title: "Char Siu Pork")
        viewModel = RecipeOverviewViewModelWithRecipes([recipe])
        
        // bind using RxSwift
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetailVC" {
            let destinationVC = segue.destination as! RecipeDetailVC
            let sender = sender as! RecipeOverviewCell
            
            destinationVC.recipeName = sender.recipeNameLabel.text
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
