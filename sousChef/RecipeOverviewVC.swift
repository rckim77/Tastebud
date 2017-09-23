//
//  RecipeOverviewVCViewController.swift
//  sousChef
//
//  Created by Raymond Kim on 5/23/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

class RecipeOverviewVC: UIViewController {

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetailVC" {
            let destinationVC = segue.destination as! RecipeDetailVC
            let sender = sender as! RecipeOverviewCell
            
            destinationVC.recipeName = sender.recipeNameLabel.text
        }
    }

}

extension RecipeOverviewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeOverviewCell", for: indexPath) as! RecipeOverviewCell
        
        cell.recipeNameLabel.text = "Char Siu Pork"
        
        return cell
    }

}
