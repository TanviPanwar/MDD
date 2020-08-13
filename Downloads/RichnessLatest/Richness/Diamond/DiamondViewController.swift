//
//  DiamondViewController.swift
//  Richness
//
//  Created by Sobura on 6/7/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit
import PassKit
import StoreKit

class DiamondViewController: PanelViewController, PKPaymentAuthorizationControllerDelegate {

    
    //MARK:- Outlets
    
    @IBOutlet var goldBtnOutlet: UIButton!
    @IBOutlet var silverBtnOutlet: UIButton!
    @IBOutlet var bronzeBtnOutlet: UIButton!
    @IBOutlet var normalBtnOutlet: UIButton!
    
    //MARK:- Variables
    var paymentRequest = PKPaymentRequest()
    var products = [SKProduct]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         reload()
        NotificationCenter.default.addObserver(self, selector: #selector(DiamondViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkProductStatus()
       
    }
    
    func reload() {
        products = []
        
       
        RichnessAlamofire.showIndicator()
        Products.store.requestProducts{success, products in
              RichnessAlamofire.hideIndicator()
            if success {
                self.products = products!
                
               
            }
            
            
        }
      
    }
    
    func checkProductStatus(){
       // var index = 0
          //  for product in products {
              
                
                if RichnessUserDefault.getUserRanking() == "0"{
                    DispatchQueue.main.async {
                        self.goldBtnOutlet.isEnabled = true
                        
                        self.silverBtnOutlet.isEnabled = false
                        
                        self.bronzeBtnOutlet.isEnabled = false
                        
                        self.normalBtnOutlet.isEnabled = false
                    }
                    
                    
                    
                }else{
                     DispatchQueue.main.async {
                    self.goldBtnOutlet.isEnabled = true
                    
                    self.silverBtnOutlet.isEnabled = true
                    
                    self.bronzeBtnOutlet.isEnabled = true
                    
                    self.normalBtnOutlet.isEnabled = true
                    }
                }
                
//                if Products.isProductPurchased(product.productIdentifier) {
//                    if index == 0{
//                        self.goldBtnOutlet.isEnabled = false
//                    }
//                    if index == 1{
//                        self.silverBtnOutlet.isEnabled = false
//                    }
//                    if index == 2{
//                        self.bronzeBtnOutlet.isEnabled = false
//                    }
//                    if index == 3{
//                        self.normalBtnOutlet.isEnabled = false
//                    }
//                } else if IAPHelper.canMakePayments() {
//                    if index == 0{
//                        self.goldBtnOutlet.isEnabled = true
//                    }
//                    if index == 1{
//                        self.silverBtnOutlet.isEnabled = true
//                    }
//                    if index == 2{
//                        self.bronzeBtnOutlet.isEnabled = true
//                    }
//                    if index == 3{
//                        self.normalBtnOutlet.isEnabled = true
//                    }
//
//               }
                    //else {
//                    detailTextLabel?.text = "Not available"
//                }
                // index += 1
         //   }
       
        
    }
    
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        for (index, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
            if product.productIdentifier == Products.productOne{
                self.productBought(type : 4 ,price : 1)
            }else if product.productIdentifier == Products.productTwo{
                self.productBought(type : 3 ,price : 2)
            }else if product.productIdentifier == Products.productThree{
                self.productBought(type : 2 ,price : 3)
                
            }else if product.productIdentifier == Products.productFour{
                self.productBought(type : 1 ,price : 4)
            }
           
         }
    }


  
    
    func payment() {
        
        let paymentNetwork = [PKPaymentNetwork.amex, .chinaUnionPay, .discover, .masterCard, .visa]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetwork){
            paymentRequest.currencyCode = "USD"
            paymentRequest.countryCode = "US"
            paymentRequest.merchantIdentifier = "merchant.com.sobura.richness"
            paymentRequest.supportedNetworks = paymentNetwork
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.requiredShippingAddressFields = .all
            paymentRequest.paymentSummaryItems = itemsToSell(shipping : 9.99)
            
            let sameDayShipping = PKShippingMethod(label: "Same day shipping", amount: 9.99)
            sameDayShipping.detail = "Item is guaranteed to deliver within the same day."
            sameDayShipping.identifier = "sameDayShipping"
            let twoDayShipping = PKShippingMethod(label: "Two day shipping", amount: 6.99)
            twoDayShipping.detail = "Item is guaranteed to deliver within the two business day."
            twoDayShipping.identifier = "twoDayShipping"
            let freeShipping = PKShippingMethod(label: "Free shipping", amount: 0)
            freeShipping.detail = "Item will deliver within 5-7 business days."
            freeShipping.identifier = "freeShipping"
            
            paymentRequest.shippingMethods = [sameDayShipping, twoDayShipping, freeShipping]
            let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            applePayVC?.delegate = self as? PKPaymentAuthorizationViewControllerDelegate
            (self.owner as! MainViewController).present(applePayVC!, animated: true, completion: nil)
        }
    }
        
    func itemsToSell(shipping: Double) -> [PKPaymentSummaryItem]{
        let techcoderxtshirt = PKPaymentSummaryItem(label: "TechCoderX Merch T-Shirt", amount: 20.00)
        let discount = PKPaymentSummaryItem(label: "Discount", amount: -3.00)
        let shippjng = PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(string : "\(shipping)"))
        let totlaAmt = techcoderxtshirt.amount.adding(discount.amount).adding(shippjng.amount)
        let totlaPrice = PKPaymentSummaryItem(label: "TechCoderx Corp.", amount: totlaAmt)
        return [techcoderxtshirt, discount, shippjng, totlaPrice]
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(.success)
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectShippingMethod shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        completion(.success, itemsToSell(shipping: Double(truncating: shippingMethod.amount)))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss(completion: nil)
    }
    
    
    
    
    
    
    
    @IBAction func onTapDiamond(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
           // byCreadit(price: 1)
            inAppPurchase(id: Products.productOne , index : 0)
            break
        case 1:
           // byCreadit(price: 2)
             inAppPurchase(id: Products.productTwo , index : 1)
            break
        case 2:
           // byCreadit(price: 3)
             inAppPurchase(id: Products.productThree , index : 2)
            break
           // byCreadit(price: 4)
           
        case 3:
              inAppPurchase(id: Products.productFour , index : 3)
            break
        default:
            break
            
        }
    }
    
   
    
    func inAppPurchase( id : String , index : Int){
        var status = checkBuyStatus(key : id)
       // if status{
         let product = products[index]
         Products.store.buyProduct(product)
        
        
            
       // }else{print("Limit reached")}
        
    }
    
    func checkBuyStatus(key : String) -> Bool{
        let defaults = UserDefaults.standard
        var currentValue = defaults.integer(forKey: key)
        
        if currentValue <= 0 {
            return false
        } else {
            currentValue -= 1
            defaults.set(currentValue, forKey: key)
            defaults.synchronize()
            return true
           
            
           
        }
    }
    
    
    
    
    //MARK:- API CALLS
    func productBought(type : Int ,price : Int){
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        let params = ["user_id" : "\(RichnessUserDefault.getUserID())" , "type" : "\(type)" , "key" : "\(key)"] as [String : AnyObject]
        RichnessAlamofire.POST(ADDDIAMOND_URL, parameters: params, showLoading: true, showSuccess: false, showError: false){ (result, responseObject)
            in
             RichnessAlamofire.hideIndicator()
            if(result){
                print(responseObject)
                self.byCreadit(price: price)
            }
            else
            {
                self.showError(errMsg: error_on_server)
            }
        }
        
        
    }
    
    func byCreadit(price : Int) {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        let params = [
            "user_id" : RichnessUserDefault.getUserID(),
            "price" : price,
            "key" : key
            ] as [String : Any]
        print(params)
        
        RichnessAlamofire.POST(PURCHASECREDIT_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
             RichnessAlamofire.hideIndicator()
            if(result){
                print(responseObject)
               
                if(responseObject.object(forKey: "result") != nil) {
                    let ranking = responseObject.object(forKey: "ranking") as? String ?? ""
                    print(ranking)
                    RichnessUserDefault.setUserRanking(val: ranking)
                    self.showSuccess(successMsg: "You bought credits successfully.")
                }
                else {
                    let error = responseObject.object(forKey: "error") as? String
                    if (error == "#997") {
                        self.showError(errMsg: user_error_unknown)
                    }
                    else {
                        self.showError(errMsg: error_on_server)
                    }
                }
            }
            else
            {
                self.showError(errMsg: error_on_server)
            }
        }
    }
    
    
    
    //END
}

            
            
            
            
