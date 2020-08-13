//
//  KeyboardDelegate.swift
//  Niah
//
//  Created by IOS3 on 12/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import Foundation
import  UIKit

class KeyboardDelegate : NSObject {
    
    var scrollView = UIScrollView()
    var activeField: UITextField?
    var view = UIView()
    var scrollType = String()
    
    var textView = UITextView()
    
    init(scrollView : UIScrollView? , activeField : UITextField? , view : UIView?  , textView  : UITextView? , scrollType : String) {
        super.init()
        self.scrollView = scrollView!
        self.activeField = activeField
        self.view = view!
        self.scrollType = scrollType
        self.textView = textView!
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShownWithScrollView(notification:)), name: Notification.Name("KEYBOARDWILLSHOW"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHiddenWithScrollView(notification:)), name: Notification.Name("KEYBOARDWILLHIDE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard(notification:)), name: Notification.Name("KEYBOARDWILLSHOWWITHTEXTVIEW"), object: nil)
    }
    
    
    
    @objc func keyboardWasShownWithScrollView(notification: NSNotification)
    {
        
            if let userInfo = notification.userInfo {
                if let keyboardSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
                    
                    var contentInset:UIEdgeInsets = self.scrollView.contentInset
                    contentInset.bottom = keyboardSize.size.height
                    scrollView.contentInset = contentInset
                } else {
                    // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
                }
            } else {
                // no userInfo dictionary in notification
            }

        
    }
    
    
    @objc func keyboardWillBeHiddenWithScrollView(notification: NSNotification)
    {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    
    
    
    
}

