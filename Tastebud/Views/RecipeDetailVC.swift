//
//  RecipeDetailVC.swift
//  Tastebud
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
    @IBOutlet var startButton: UIButton!
    
    @IBAction func startPressed(_ sender: UIButton) {
        
    }
    
    var viewModel: RecipeDetailViewModelWithRecipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.isUserInteractionEnabled = false
        // TODO: Make network call to get procedure data for this recipe; disable start button until data is loaded successfully
        UIView.animate(withDuration: 1.0, delay: 3.0, options: .curveEaseInOut, animations: {
            self.startButton.backgroundColor = .green
            self.startButton.isUserInteractionEnabled = true
        }, completion: nil)
        
//        durationLabel.text = "Total: 9 hrs. Active: 1 hr"
        guard let recipe = viewModel else { return }
        
        recipeNameLabel.text = recipe.title
        durationLabel.text = recipe.duration
        ingredientsTitleLabel.text = "Ingredients"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeProcedureVC" {
            if let destinationVC = segue.destination as? RecipeProcedureVC {
                destinationVC.viewModel = RecipeProcedureViewModelWithProcedure(ProcedureModel())
            }
        }
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
