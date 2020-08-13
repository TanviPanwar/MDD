//
//  Products.swift
//  Richness
//
//  Created by iOS6 on 19/04/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import Foundation

public struct Products {
    
    public static let productOne = "com.subora.richness.buy200"
    public static let productTwo = "com.sobura.richness.buy600"
    public static let productThree = "com.sobura.richness.buy800"
    public static let productFour = "com.sobura.richness.buy1000"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [Products.productOne , Products.productTwo  , Products.productThree  , Products.productFour ]
    
    public static let RandomRageFace = "com.razeware.rageswift3.RandomRageFace"
    
    // fileprivate static let productIdentifiers: Set<ProductIdentifier> =
    //    [RageProducts.productOne,
    //    RageProducts.RandomRageFace]
    
    public static let store = IAPHelper(productIds: Products.productIdentifiers)
    
    public static func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        if (productIdentifier != Products.productOne) || (productIdentifier != Products.productTwo) || (productIdentifier != Products.productThree) || (productIdentifier != Products.productFour) {
            return false
        } else {
            return Products.store.isProductPurchased(productIdentifier)
        }
    }
    
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

