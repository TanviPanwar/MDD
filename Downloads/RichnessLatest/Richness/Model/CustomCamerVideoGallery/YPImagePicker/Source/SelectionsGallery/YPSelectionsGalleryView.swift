//
//  YPSelectionsGalleryView.swift
//  YPImagePicker
//
//  Created by Sacha DSO on 13/06/2018.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import UIKit
//import Stevia

class YPSelectionsGalleryView: UIView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: YPGalleryCollectionViewFlowLayout())
    let upperLine = UIView()
    let lowerLine = UIView()
    
    convenience init() {
        self.init(frame: .zero)
    
        sv(
            lowerLine,
            collectionView
            //upperLine

        )
        
        // Layout collectionView
        collectionView.heightEqualsWidth()
        if #available(iOS 11.0, *) {
            lowerLine.Top == safeAreaLayoutGuide.Bottom
            collectionView.Right == safeAreaLayoutGuide.Right
            collectionView.Left == safeAreaLayoutGuide.Left

        } else {
            |lowerLine|
            |collectionView|

        }
        collectionView.CenterY == CenterY - 30
        
        // Apply style
        backgroundColor =  UIColor(r: 247, g: 247, b: 247)
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false

//        let upperLine = UIView()
//        let lowerLine = UIView()
//        upperLine.height(2)
//        upperLine.width(1000)
        lowerLine.height(2)
        lowerLine.width(UIScreen.main.bounds.size.width)

//        upperLine.backgroundColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)
        lowerLine.backgroundColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)
//
//        upperLine.Top == collectionView.Top
    }
}

class YPGalleryCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        scrollDirection = .horizontal
        let sideMargin: CGFloat = 24
        let spacing: CGFloat = 12
        let overlapppingNextPhoto: CGFloat = 37
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing
        let size = UIScreen.main.bounds.width - (sideMargin + overlapppingNextPhoto)
        itemSize = CGSize(width: size, height: size)
        sectionInset = UIEdgeInsets(top: 0, left: sideMargin, bottom: 0, right: sideMargin)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This makes so that Scrolling the collection view always stops with a centered image.
    // This is heavily inpired form :
    // https://stackoverflow.com/questions/13492037/targetcontentoffsetforproposedcontentoffsetwithscrollingvelocity-without-subcla
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let spacing: CGFloat = 12
        let overlapppingNextPhoto: CGFloat = 37
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude// MAXFLOAT
        let horizontalOffset = proposedContentOffset.x + spacing + overlapppingNextPhoto/2 // + 5
        
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        guard let array = super.layoutAttributesForElements(in: targetRect) else {
            return proposedContentOffset
        }
        
        for layoutAttributes in array {
            let itemOffset = layoutAttributes.frame.origin.x
            if abs(itemOffset - horizontalOffset) < abs(offsetAdjustment) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
