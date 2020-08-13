//
//  TextViewDelegate.swift
//  Niah
//
//  Created by IOS3 on 15/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import Foundation
import UIKit

class TextViewDelegate : NSObject , UITextViewDelegate  {
    
    var onCompletion  : ((Int) -> ())?
    var view = UIView()
    var source = String()
    
    
    init(view : UIView? , onCompletion  : ((Int) -> ())? , source : String) {
        self.view = view!
        self.source = source
        self.onCompletion = onCompletion

    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if source == "Chat"{
          //  onCompletion!(-textView.tag)
        }else{
        if let textViewWithTag = view.viewWithTag(textView.tag) as? UITextView {
            
            textViewWithTag.text = ""
            textViewWithTag.textColor = UIColor.black
            onCompletion!(textView.tag)
        }else {
            
            }}
        return true
        
    }

    func textViewDidChange(_ textView: UITextView) {
        if source == "Chat"{
            onCompletion!(textView.tag)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if source == "Chat"{
         //   onCompletion!(-textView.tag)
        }
    }






}

