//
//  PreviewPhotoViewController.swift
//  Richness
//
//  Created by iOS6 on 19/02/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import UIKit
import PullToRefresh
import SDWebImage
import Player
import  IQKeyboardManagerSwift
import AVFoundation
import AVKit

//public enum SaveType1 {
//    case none
//    //case rectangle(ratio: Double)
//}

class PreviewPhotoViewController: UIViewController {
    
    public var didFinishSaving: ((UIImage) -> Void)?
    
    private var originalImage: UIImage
    var ProfileImage : Data? = nil
    
    required init(image: UIImage) {
        originalImage = image
        super.init(nibName: nil, bundle: nil)

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var doneBtn: UIButton!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
       photoView.image = originalImage
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    // MARK:-
    // MARK:- IB Actions
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        
//        let saveVC:SavePhotoViewController = self.storyboard?.instantiateViewController(withIdentifier:"SavePhotoViewController") as! SavePhotoViewController
//            saveVC.didFinishSaving = { savedImage in
//                self.photoView.image! = savedImage
//               // completion(photo)
//            }
        
        if case let saveVC = SavePhotoViewController(image: originalImage) {
            saveVC.didFinishSaving = { savedImage in
                self.originalImage = savedImage
                //completion(photo)
            }
        
            self.navigationController?.pushViewController(saveVC, animated: true)
        
        
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
