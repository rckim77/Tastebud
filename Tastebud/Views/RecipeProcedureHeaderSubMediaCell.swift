//
//  RecipeProcedureHeaderSubMediaCell.swift
//  Tastebud
//
//  Created by Raymond Kim on 5/23/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

class RecipeProcedureHeaderSubMediaCell: UICollectionViewCell {
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var subheaderLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var widthConstraint: NSLayoutConstraint!
    
    var isHeightCalculated = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        widthConstraint.constant = UIScreen.main.bounds.size.width
    }
    
}
