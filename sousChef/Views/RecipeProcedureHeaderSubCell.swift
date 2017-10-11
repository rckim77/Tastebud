//
//  RecipeProcedureHeaderSubCell.swift
//  sousChef
//
//  Created by Raymond Kim on 10/5/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

class RecipeProcedureHeaderSubCell: UICollectionViewCell {
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var subheaderLabel: UILabel!
    @IBOutlet var widthConstraint: NSLayoutConstraint!
    
    var isHeightCalculated = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        widthConstraint.constant = UIScreen.main.bounds.size.width
    }

}
