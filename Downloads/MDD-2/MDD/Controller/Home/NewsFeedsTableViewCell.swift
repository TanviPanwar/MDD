//
//  NewsFeedsTableViewCell.swift
//  MDD
//
//  Created by iOS6 on 19/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class NewsFeedsTableViewCell: UITableViewCell {

    
    //MARK:- Outlets
    @IBOutlet var feedImageView: UIImageView!
    @IBOutlet var newsChannelTitleLbl: UILabel!
    @IBOutlet var newsLbl: UILabel!
    @IBOutlet var newsBottomLbl: UILabel!
    @IBOutlet var borderView: UIView!
    
    //MARK:- Object Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
  
}
