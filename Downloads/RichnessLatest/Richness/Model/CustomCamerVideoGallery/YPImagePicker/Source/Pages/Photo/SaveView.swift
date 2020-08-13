//
//  SaveView.swift
//  Richness
//
//  Created by IOS3 on 23/01/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit
//import Stevia

class SaveView: UIView {

    let imageView = UIImageView()
    let topCurtain = UIView()
    let cropArea = UIView()
    let bottomCurtain = UIView()
    let toolbar = UIToolbar()
    let lowerArea = UIView()
    let descriptionText = UITextView()
    let upperline = UIView()
    let lowerline = UIView()
    let lowerTextLine = UIView()





    convenience init(image: UIImage) {
        self.init(frame: .zero)
        setupViewHierarchy()
        setupLayout(with: image)
        applyStyle()
        imageView.image = image
    }

    private func setupViewHierarchy() {
        sv(
            imageView,
            topCurtain,
            cropArea,
            bottomCurtain,
            toolbar,
            lowerArea,
            descriptionText,
            upperline,
           lowerline,
           lowerTextLine

        )
    }

    private func setupLayout(with image: UIImage) {
        //        layout(
        //            0,
        //            |topCurtain|,
        //            |cropArea|,
        //            |bottomCurtain|,
        //            0
        //        )
        // |lowerArea|

        layout(
                        0,
                        |lowerline|,
                        |imageView|,
                        |upperline|,
                        |descriptionText|,
                        |lowerTextLine|,
                        |toolbar|
                    )
        //|toolbar|

        //

        if #available(iOS 11.0, *) {
            lowerline.Top == safeAreaLayoutGuide.Top
            imageView.Top == lowerline.Top
            upperline.Top == imageView.Bottom

           descriptionText.Top == imageView.Bottom
            descriptionText.Leading == 20
            descriptionText.Trailing == 20
           //lowerline.Top == descriptionText.Bottom
            lowerTextLine.Top == descriptionText.Bottom


           toolbar.Bottom == safeAreaLayoutGuide.Bottom + 25
           //toolbar.Top == lowerline.Bottom
            //             lowerArea.Bottom == toolbar.Bottom
            //            lowerArea.height(100)
            //            lowerArea.width(UIScreen.main.bounds.size.width)
        } else {
            lowerline.top(0)
            imageView.top(0)
            upperline.top(0)

            descriptionText.top(0)
            lowerTextLine.top(0)


            toolbar.bottom(0)
            //            lowerArea.bottom(0)
            //            lowerArea.height(100)
            //            lowerArea.width(UIScreen.main.bounds.size.width)

        }
//        let isIphone4 = UIScreen.main.bounds.height == 480
//        let sideMargin: CGFloat = isIphone4 ? 20 : 0
      
        //
        //        let r: CGFloat = CGFloat(1.0 / ratio)
        //        cropArea.Height == cropArea.Width * r
        //        cropArea.centerVertically()
        //
        // Fit image differently depnding on its ratio.
        lowerline.height(2)
        lowerline.width(UIScreen.main.bounds.width)
        lowerline.backgroundColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)


        let imageRatio: Double = Double(image.size.width / image.size.height)

            let scaledDownRatio = UIScreen.main.bounds.width / image.size.width
            imageView.width(image.size.width * scaledDownRatio )
            imageView.centerInContainer()



        // Fit imageView to image's bounds
        imageView.Width == imageView.Height
        upperline.height(2)
        upperline.width(UIScreen.main.bounds.width)

        upperline.backgroundColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)

        descriptionText.width(UIScreen.main.bounds.width)
        descriptionText.height(100)



        lowerTextLine.height(2)
        lowerTextLine.width(UIScreen.main.bounds.width)

        lowerTextLine.backgroundColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)


    }

    private func applyStyle() {
        backgroundColor = .black
        clipsToBounds = true
        imageView.style { i in
            i.isUserInteractionEnabled = true
            i.isMultipleTouchEnabled = true
        }
        //        topCurtain.style(curtainStyle)
        //        cropArea.style { v in
        //            v.backgroundColor = .clear
        //            v.isUserInteractionEnabled = false
        //        }
        //        bottomCurtain.style(curtainStyle)
        descriptionText.style { l in
            l.isUserInteractionEnabled = true
            l.textColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)
            l.text = "Add a description here..."
           l.backgroundColor = .black
            l.font = .monospacedDigitSystemFont(ofSize: 13, weight: UIFont.Weight.medium)
        }
        toolbar.style { t in
            t.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
            t.setShadowImage(UIImage(), forToolbarPosition: .any)
        }
        //        lowerArea.style{ l in
        //           l.backgroundColor = .black
        //            //v.lowerArea = false
        //
        //        }
    }

    //    func curtainStyle(v: UIView) {
    //        v.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    //        v.isUserInteractionEnabled = false
    //    }
}
