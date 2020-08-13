//
//  ObservationsCollectionReusableView.swift
//  MDD
//
//  Created by iOS6 on 26/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class ObservationsCollectionReusableView: UICollectionReusableView {
    
    
    @IBOutlet weak var uploadFileBtn: UIButton!
    @IBOutlet weak var chooseFileBtn: UIButton!
    @IBOutlet weak var enterCaptionTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    public var onUploadButtonTapped : (() ->Void)? = nil
    public var onChooseFileButtonTapped : (() ->Void)? = nil
    public var onSubmitButtonTapped : (() ->Void)? = nil
    
    
    @IBAction func uploadFileBtnaction(_ sender: Any) {
        
        onUploadButtonTapped!()
        
    }
    
    @IBAction func chooseFileBtnAction(_ sender: Any) {
        
        onChooseFileButtonTapped!()
        
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        onSubmitButtonTapped!()
        
    }
}
