//
//  ProfileCollectionCell.swift
//  Richness
//
//  Created by IOS3 on 07/02/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit

class ProfileCollectionCell: UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playVideoImage: UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
