//
//  HomeCVC.swift
//  MDD
//
//  Created by IOS3 on 20/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class HomeCVC: UICollectionViewCell {
    //MARK:- Outlets
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var weather_image: UIImageView!
    @IBOutlet weak var weather_image_height: NSLayoutConstraint!
    @IBOutlet weak var catNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

}
