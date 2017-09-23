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
    
    var recipeName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeNameLabel.text = recipeName
        durationLabel.text = "Total: 9 hrs. Active: 1 hr"
    }

}

extension RecipeDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
        
        switch indexPath.row {
        case 0:
            cell.ingredientLabel.text = "2kg pork shoulder, boneless"
        case 1:
            cell.ingredientLabel.text = "20g salt"
        case 2:
            cell.ingredientLabel.text = "230g char siu sauce (e.g., Lee Kum Kee)"
        case 3:
            cell.ingredientLabel.text = "300g spicy mustard, for garnish"
        case 4:
            cell.ingredientLabel.text = "150g green onions, for garnish"
        case 5:
            cell.ingredientLabel.text = "75g sesame seeds, for garnish"
        default:
            cell.ingredientLabel.text = ""
        }
        
        return cell
    }
}
