//
//  RecipeOverviewVCViewController.swift
//  Tastebud
//
//  Created by Raymond Kim on 5/23/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

class RecipeOverviewVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: RecipeOverviewViewModel?
    // by replacing nil with another view controller, you can show a different VC for the search results
    let searchController = UISearchController(searchResultsController: nil)
    var filteredRecipes = [RecipeDetailViewModelWithRecipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
        let ingredients = [IngredientModel(title: "pork shoulder, boneless", measurement: "2kg"),
                           IngredientModel(title: "salt", measurement: "20g"),
                           IngredientModel(title: "char siu sauce (e.g., Lee Kum Kee)", measurement: "230g"),
                           IngredientModel(title: "spicy mustard, for garnish", measurement: "300g"),
                           IngredientModel(title: "green onions, for garnish", measurement: "150g"),
                           IngredientModel(title: "sesame seeds, for garnish", measurement: "75g")]
        
        let recipeDetailViewModel = RecipeDetailViewModelWithRecipe(RecipeModel(imageURL: "", title: "Char Siu Pork", duration: "Total: 9 hrs. Active: 1 hr", ingredients: ingredients))
        viewModel = RecipeOverviewViewModelWithRecipes([recipeDetailViewModel, recipeDetailViewModel, recipeDetailViewModel, recipeDetailViewModel, recipeDetailViewModel, recipeDetailViewModel, recipeDetailViewModel])
        
        // bind using RxSwift
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetailVC" {
            let destinationVC = segue.destination as! RecipeDetailVC
            let sender = sender as! RecipeOverviewCell
            if let senderIndex = collectionView.indexPath(for: sender)?.row {
                if isFiltering() {
                    destinationVC.viewModel = filteredRecipes[senderIndex]
                } else {
                    destinationVC.viewModel = viewModel?.recipes[senderIndex]
                }
            }
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        // set to true if you're displaying another VC for searchResultsController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recipes"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        // prevents the search bar from remaining on screen when user navigates to another VC while
        // search controller is active
        definesPresentationContext = true
    }
    
    // MARK: private instance methods
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        guard let recipes = viewModel?.recipes else { return }
        filteredRecipes = recipes.filter({(recipe: RecipeDetailViewModelWithRecipe) -> Bool in
            return recipe.title.lowercased().contains(searchText.lowercased())
        })
        
        collectionView.reloadData()
    }
    

}

// MARK: UICollectionView methods
extension RecipeOverviewVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredRecipes.count
        }
        
        return viewModel?.recipes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let recipes = viewModel?.recipes, recipes.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeOverviewCell.identifier, for: indexPath) as! RecipeOverviewCell
            
            if isFiltering() {
                cell.recipeNameLabel.text = filteredRecipes[indexPath.row].title
            } else {
                cell.recipeNameLabel.text = recipes[indexPath.row].title
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
}

// MARK: UISearchResultsUpdating Delegate
extension RecipeOverviewVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
