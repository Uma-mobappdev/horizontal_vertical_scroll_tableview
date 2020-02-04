//
//  CellImageView.swift
//  RumblApp
//
//  Created by Umamaheshwari on 29/01/20.
//  Copyright © 2020 Umamaheshwari. All rights reserved.
//

import UIKit

class CellImageView: UICollectionViewCell {
    
    @IBOutlet var imageViewPoster: UIImageView!
    
    override func prepareForReuse() {
        imageViewPoster.image = nil
        super.prepareForReuse()
    }
}
