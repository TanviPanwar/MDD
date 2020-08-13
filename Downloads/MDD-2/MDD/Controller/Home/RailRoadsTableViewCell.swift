//
//  RailRoadsTableViewCell.swift
//  MDD
//
//  Created by iOS6 on 10/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class RailRoadsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
