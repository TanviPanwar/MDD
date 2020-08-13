//
//  YPCameraView.swift
//  YPImgePicker
//
//  Created by Sacha Durand Saint Omer on 2015/11/14.
//  Copyright © 2015 Yummypets. All rights reserved.
//

import UIKit
//import Stevia

public class YPCameraView: UIView, UIGestureRecognizerDelegate {
    
    let focusView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
    let previewViewContainer = UIView()
    let buttonsContainer = UIView()
    let flipButton = UIButton()
    let shotButton = UIButton()
    let flashButton = UIButton()
    let timeElapsedLabel = UILabel()
    let progressBar = UIProgressView()
    let flashLabel = UILabel()
    let upperLine = UIView()
    let lowerLine = UIView()



    convenience init(overlayView: UIView? = nil) {
        self.init(frame: .zero)
        //self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        if let overlayView = overlayView {
            // View Hierarchy
            sv(
                previewViewContainer,
                overlayView,
                progressBar,
                timeElapsedLabel,
                flashButton,
                flipButton,
                flashLabel,
                buttonsContainer.sv(
                    shotButton
                ),
                upperLine,
                lowerLine
            )
        } else {
            // View Hierarchy
            sv(
                previewViewContainer,
                progressBar,
                timeElapsedLabel,
                flashButton,
                flipButton,
                flashLabel,
                buttonsContainer.sv(
                    shotButton
                )
                ,
                upperLine,
                lowerLine
            )
        }
        
//        if let overlayView = overlayView {
//            // View Hierarchy
//            sv(
//                previewViewContainer.sv(buttonsContainer.sv(shotButton)),
//                overlayView,
//                progressBar,
//                timeElapsedLabel,
//                flashButton,
//                flipButton,
//                flashLabel,
////                buttonsContainer.sv(
////                    shotButton
////                ),
//                upperLine,
//                lowerLine
//            )
//        } else {
//            // View Hierarchy
//            sv(
//                previewViewContainer.sv(buttonsContainer.sv(shotButton)),
//                progressBar,
//                timeElapsedLabel,
//                flashButton,
//                flipButton,
//                flashLabel,
////                buttonsContainer.sv(
////                    shotButton
////                )
////                ,
//                upperLine,
//                lowerLine
//            )
//        }
      
        
        
        // Layout
        let isIphone4 = UIScreen.main.bounds.height == 480
        let sideMargin: CGFloat = isIphone4 ? 20 : 0
        layout(
            0,
            |-sideMargin-previewViewContainer-sideMargin-|,
            -2,
            |progressBar|,
            0,
           |buttonsContainer|,
            0
        )
           previewViewContainer.heightEqualsWidth()
//        previewViewContainer.height(500)
//        previewViewContainer.width(375)
        // previewViewContainer.frame = CGRect(x: 0, y: 50, width: 375, height: 500)

       overlayView?.followEdges(previewViewContainer)


//        |-(15+sideMargin)-flashButton.size(42)
//        flashButton.Bottom == previewViewContainer.Bottom - 15
//
//        flipButton.size(42)-(15+sideMargin)-|
//        flipButton.Bottom == previewViewContainer.Bottom - 15
//        upperLine.size(width(375), height(2))
//        upperLine.Bottom == previewViewContainer.Bottom - 0
//        upperLine.frame = CGRect(origin: self.previewViewContainer.frame.size.width, size: 2.0)
//        lowerLine.frame = CGRect(origin: self.previewViewContainer.frame.size.width, size: 2.0)
   
        
        
//        buttonsContainer.frame = CGRect(x:previewViewContainer.frame.origin.x , y: (previewViewContainer.frame.origin.x + previewViewContainer.frame.size.height) - 100, width: UIScreen.main.bounds.width, height: 300)
//
//        buttonsContainer.Bottom == previewViewContainer.Bottom
        
        upperLine.height(2)
        upperLine.width(1000)
        lowerLine.height(2)
        lowerLine.width(1000)
        upperLine.backgroundColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)
        lowerLine.backgroundColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)

        upperLine.Bottom == previewViewContainer.Bottom
        lowerLine.Bottom == previewViewContainer.Top + 2


        |-(15+sideMargin)-flipButton.size(42)
        flipButton.Bottom == previewViewContainer.Bottom - 15

        flashButton.size(42)-(45+sideMargin)-|
        flashButton.Bottom == previewViewContainer.Bottom - 15
        
        flashLabel-(10+sideMargin)-|
        flashLabel.Bottom == previewViewContainer.Bottom - 27
        //flashLabel.CenterX == flashButton.CenterX

        //timeElapsedLabel.centerVertically()   //-(15+sideMargin)-|
        timeElapsedLabel.centerHorizontally()
        timeElapsedLabel.Top == previewViewContainer.Top + 15
        
        shotButton.centerVertically()
        shotButton.size(84).centerHorizontally()

        // Style
        backgroundColor = YPConfig.colors.photoVideoScreenBackground
        previewViewContainer.backgroundColor = .black
        timeElapsedLabel.style { l in
            l.textColor = .white
            l.text = "00:00"
            l.isHidden = true
            l.font = .monospacedDigitSystemFont(ofSize: 13, weight: UIFont.Weight.medium)
        }

        flashLabel.style { f in
            f.textColor = .white
            f.text = "Auto"
            //f.isHidden = true
            f.font = .monospacedDigitSystemFont(ofSize: 17, weight: UIFont.Weight.medium)
        }

        progressBar.style { p in
            p.trackTintColor = .clear
            p.tintColor = .red
        }
        flashButton.setImage(YPConfig.icons.flashOffIcon, for: .normal)
        flipButton.setImage(YPConfig.icons.loopIcon, for: .normal)
        shotButton.setImage(YPConfig.icons.capturePhotoImage, for: .normal)
    }
}
