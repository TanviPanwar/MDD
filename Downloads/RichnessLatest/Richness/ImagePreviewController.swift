//
//  ImagePreviewController.swift
//  Richness
//
//  Created by Sobura on 6/7/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit

class ImagePreviewController: UIViewController, UIScrollViewDelegate {
    
    var image = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(exitPreview))
        imgView.addGestureRecognizer(tap)
        
//        self.scrollView.minimumZoomScale = 1.0
//        self.scrollView.maximumZoomScale = 3.0
        
        self.imgView.sd_setImage(with: URL(string : image))
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
    @IBAction func onTapCancel(_ sender: UIButton) {
        
        self.leftToRight()
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func exitPreview() {
        
        self.leftToRight()
        self.dismiss(animated: false, completion: nil)
    }
}
