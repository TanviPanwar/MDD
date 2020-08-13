//
//  SearchInd&EmpCollectionViewCell.swift
//  MDD
//
//  Created by iOS6 on 08/08/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class SearchInd_EmpCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    public var onDeleteButtonTapped : (() ->Void)? = nil
    
    
    @IBAction func deleteBtnAction(_ sender: Any) {
        
        onDeleteButtonTapped!()
    }
    
}
