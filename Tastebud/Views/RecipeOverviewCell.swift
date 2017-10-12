//
//  RecipeOverviewCellCollectionViewCell.swift
//  Tastebud
//
//  Created by Raymond Kim on 5/23/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

class RecipeOverviewCell: UICollectionViewCell {
    
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var recipeOverview: RecipeModel? {
        didSet {
            guard let recipeOverview = recipeOverview else { return }
            
            recipeNameLabel.text = recipeOverview.title
            // image
        }
    }
    
    
}
