//
//  HomeVC.swift
//  MDD
//
//  Created by IOS3 on 20/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SDWebImage
import Fabric
import Crashlytics



class HomeVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    
    //MARK:- Outlets
    @IBOutlet weak var mainTableview: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var top_bg_view: UIView!
    @IBOutlet weak var top_bg_view_height: NSLayoutConstraint!
    @IBOutlet weak var top_bg_view_top: NSLayoutConstraint!
    @IBOutlet weak var detail_btn_outlet: UIButton!
    @IBOutlet weak var detail_btn_height: NSLayoutConstraint!
    @IBOutlet weak var detail_btn_top: NSLayoutConstraint!
    @IBOutlet weak var weather_collection_view: UICollectionView!
    @IBOutlet weak var superview_of_weather_collectionview: UIView!
    @IBOutlet weak var location_bottom_constraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var datelLabel: UILabel!
    @IBOutlet weak var titlelLabel: UILabel!
    @IBOutlet weak var locationlLabel: UILabel!
    
    @IBOutlet weak var tickerCollectionView: UICollectionView!
    @IBOutlet weak var topViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var weatherCollectionHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var tickerCollectionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var superViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var backwardBtn: UIButton!
    
    
    var categoryArray = [CategoryObjectModel]()
    var pdfArray = [CategoryObjectModel]()


    //MARK:- Object Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
        
//        let newMultiplier:CGFloat = 0.6
//        topViewHeightConst = topViewHeightConst.setMultiplier(multiplier: newMultiplier)
//
//            let newMultiplier1:CGFloat = 0.62
//            superViewHeightConst = superViewHeightConst.setMultiplier(multiplier: newMultiplier1)
            
            
            
            
            
            
//            let newMultiplier2:CGFloat = 0.36
//                       tickerCollectionHeightConst = tickerCollectionHeightConst.setMultiplier(multiplier: newMultiplier2)
            
           //            let newMultiplier1:CGFloat = 0.9
           //            weatherCollectionHeightConst = weatherCollectionHeightConst.setMultiplier(multiplier: newMultiplier1)
            
        }
        
         mainTableview.tableFooterView = UIView()
        
        categoryListingApi()

        viewDidLoadFunctions()
       
    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewWillAppearFunctions()

    }
    
    override func viewDidLayoutSubviews() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
        super.viewDidLayoutSubviews()
            var  height =  UIScreen.main.bounds.height

        self.headerView = mainTableview.tableHeaderView
        var headerFrame = self.headerView.frame
        //Comparison necessary to avoid infinite loop

        if height != headerFrame.size.height {
            headerFrame.size.height = height
            headerView.frame = headerFrame
            self.mainTableview.tableHeaderView = headerView
        }

            
        }
  //    self.topAddCollectionView.collectionViewLayout.invalidateLayout()
    }

    
    //MARK:- Functions
    func viewDidLoadFunctions(){
         navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }



    func viewWillAppearFunctions(){
        setupUI()
    }



    func setupUI(){

        detail_btn_outlet.layer.cornerRadius = 12
        detail_btn_outlet.clipsToBounds = true

        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.title  = "CAT 365"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {

           let frame: CGRect = CGRect(x : contentOffset ,y : tickerCollectionView.contentOffset.y ,width : tickerCollectionView.frame.width,height : tickerCollectionView.frame.height)
           tickerCollectionView.scrollRectToVisible(frame, animated: true)
       }
    

    //MARK:- Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == tickerCollectionView {
            
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                
                 return CGSize(width: UIScreen.main.bounds.width - 60, height: 140)
                
            } else {

             return CGSize(width: UIScreen.main.bounds.width - 60, height: 91)
                
            }

        } else {
        
            return CGSize(width: (self.weather_collection_view.frame.width + 60)/2, height: self.weather_collection_view.frame.height)

        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
   
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == tickerCollectionView {
            
            return (pdfArray.count)
            
        } else {
            return (categoryArray.count - 1)
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == weather_collection_view {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath) as? HomeCVC  else{
            return UICollectionViewCell()
        }
        
        cell.cellView.layer.cornerRadius = 10
        cell.cellView.layer.borderWidth = 1
        cell.cellView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.748321963)
        cell.cellView.clipsToBounds = true
        
        cell.catNameLabel.text = categoryArray[indexPath.row + 1].cat_name
        if  categoryArray[indexPath.row + 1].location == "" {
            cell.locationLabel.text = "Demo"
            cell.locationLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
 
        }
        else {
        cell.locationLabel.text = categoryArray[indexPath.row + 1].location
             cell.locationLabel.textColor = UIColor.lightGray
            
        }
        cell.dateLabel.text = categoryArray[indexPath.row + 1].date
        
        print("image link: ",categoryArray[indexPath.row + 1].image)
        cell.weather_image.sd_setImage(with: URL(string : categoryArray[indexPath.row + 1].image), placeholderImage:#imageLiteral(resourceName: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
            
            if image != nil {
                
                
                print("true", image)
            }
            
            else {
              
                print("false")
                
            }
            
        }
   
        return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tickerCell", for: indexPath) as? TickerCollectionViewCell  else{
                       return UICollectionViewCell()
                   }
            
            cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 10)
            
            cell.titleLabel.text = pdfArray[indexPath.row].title
           
            cell.contentLabel.text = pdfArray[indexPath.row].postContent.html2String
            
            if pdfArray[indexPath.row].fileUrl.isEmpty {
                
                cell.pdfBtn.isHidden = true
                
            } else {
                
                cell.pdfBtn.isHidden = false
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.titleTapped(_:)))
                cell.titleLabel.tag = indexPath.row

                cell.titleLabel.isUserInteractionEnabled = true
                cell.titleLabel.addGestureRecognizer(tap)
                
                let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.contentTapped(_:)))
                cell.contentLabel.tag = indexPath.row

                cell.contentLabel.isUserInteractionEnabled = true
                cell.contentLabel.addGestureRecognizer(tap1)

                

            }
            
            cell.onPdfTapped = {
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentTweetsViewController") as! RecentTweetsViewController
                
                
                vc.titleStr = self.pdfArray[indexPath.row].title
                vc.homeObj = self.pdfArray[indexPath.row].fileUrl
                vc.homeBool = true
                self.present(vc, animated: true, completion: nil)
                
            }

            
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == weather_collection_view {
        if categoryArray.count > 0 {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        vc.obj = self.categoryArray[indexPath.row + 1]
        
        self.present(vc, animated: true, completion: nil)
            
        } else {
            
            
        }
            
        } else {
        
            if pdfArray[indexPath.row].fileUrl.isEmpty {
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentTweetsViewController") as! RecentTweetsViewController
                
                
                vc.titleStr = self.pdfArray[indexPath.row].title
                vc.homeObj = self.pdfArray[indexPath.row].postUrl
                vc.homeBool = true
                self.present(vc, animated: true, completion: nil)
                
            } else {
                
                
                
            }
            
        }
        
    }

    //MARK:- ScrollView Methods
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    //MARK:- IB Actions
    
    @IBAction func sideMenuBtnAction(_ sender: Any) {
        
        sideMenuController?.revealMenu()
        
    }
    
    
    @IBAction func detailBtnAction(_ sender: Any) {
        
        
        if categoryArray.count > 0 {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

           vc.obj = self.categoryArray[0]
        
          self.present(vc, animated: true, completion: nil)
            
        } else {
            
            
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        vc.obj = self.categoryArray[0]
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func labelTap(_ sender: UILabel) {
       
        
    }
    
    @objc func titleTapped(_ recognizer: UITapGestureRecognizer) {

        print(recognizer.view!.tag)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentTweetsViewController") as! RecentTweetsViewController
        
        
        vc.titleStr = self.pdfArray[recognizer.view!.tag].title
        vc.homeObj = self.pdfArray[recognizer.view!.tag].fileUrl
        vc.homeBool = true
        self.present(vc, animated: true, completion: nil)
        

    }
    
    
    @objc func contentTapped(_ recognizer: UITapGestureRecognizer) {

        print(recognizer.view!.tag)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentTweetsViewController") as! RecentTweetsViewController
        
        
        vc.titleStr = self.pdfArray[recognizer.view!.tag].title
        vc.homeObj = self.pdfArray[recognizer.view!.tag].fileUrl
        vc.homeBool = true
        self.present(vc, animated: true, completion: nil)
        

      }
    
    @IBAction func forwardBtnAction(_ sender: Any) {
        
        print("forward")
        let collectionBounds = self.tickerCollectionView.bounds
        let contentOffset = CGFloat(floor(self.tickerCollectionView.contentOffset.x + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
//
        
//        let visibleItems: NSArray = self.tickerCollectionView.indexPathsForVisibleItems as NSArray
//           let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
//           let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
//          print(currentItem.item)
//           print(nextItem.item)
//                  if nextItem.item < pdfArray.count {
//               self.tickerCollectionView.scrollToItem(at: nextItem, at: .right, animated: true)
//
//           }
        
        
        
        
        
        
    
    }
    
    
    @IBAction func backwardBtnAction(_ sender: Any) {
        
      print("backward")
        let collectionBounds = tickerCollectionView.bounds
        let contentOffset = CGFloat(floor(tickerCollectionView.contentOffset.x - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
        
        
//        let visibleItems: NSArray = self.tickerCollectionView.indexPathsForVisibleItems as NSArray
//        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
//        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
//        if nextItem.row < pdfArray.count && nextItem.row >= 0{
//            self.tickerCollectionView.scrollToItem(at: nextItem, at: .right, animated: true)
//
//        }
        
        
        
    }
    
    
 
    //MARK:-
    //MARK:- API Methods
    
    func categoryListingApi()
    {
        
        
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
        
            let params = ["user_id":userId!] as [String: Any]
            print(params)
    
            if Server.sharedInstance.isInternetAvailable()
            {
                Server.sharedInstance.showLoader()
                
                
                Alamofire.request(K_Base_Url+K_CAT365_listing_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
                    .responseJSON { response in
                        
                        Server.sharedInstance.stopLoader()
                        
                        // check for errors
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling GET on /todos/1")
                            print(response.result.error!)
                            return
                        }
                        print(response.result.value!)
                        // make sure we got some JSON since that's what we expect
                        guard let json = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                            }
                            return
                        }
                        
                        print(json)
                        // let status = json["status"] as? Int
                        let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json as NSDictionary)
                        let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                        if status.boolValue {
                            
                            
                            if let response = json["repsonse"] as? NSArray , response.count > 0 {
                                
                              let responseArray = Server.sharedInstance.GetCategoryListObjects(array: response)
                                
                                self.categoryArray.append(contentsOf: responseArray)
                                
                                self.datelLabel.text = self.categoryArray[0].date
                                self.titlelLabel.text = self.categoryArray[0].cat_name
                                self.locationlLabel.text = self.categoryArray[0].location
                                self.detail_btn_outlet.sd_setBackgroundImage(with: URL(string : self.categoryArray[0].image), for: .normal, completed: nil)
                                
                                
                                let view = UIView(frame: self.topView.frame)
                                let gradient = CAGradientLayer()
                                gradient.frame = view.frame
                                gradient.colors = [UIColor.clear.cgColor,UIColor.black.cgColor, UIColor.black.cgColor]
                                view.layer.insertSublayer(gradient, at: 0)
                                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                                view.addGestureRecognizer(tap)
                                self.detail_btn_outlet.addSubview(view)
                                self.detail_btn_outlet.bringSubviewToFront(view)
                               // self.weather_collection_view.reloadData()

                                
                            }
 
                            if let pdf = json["pdf"] as? NSArray , pdf.count > 0 {
                             
                                self.pdfArray = Server.sharedInstance.GetPdfListObjects(array: pdf)
  
                            }
                            
                             self.weather_collection_view.reloadData()
                             self.tickerCollectionView.reloadData()
                            
                        } else {
                            
                            DispatchQueue.main.async {
                              Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                                
                            }
                        }
                }
                
            }
                
            else {
                DispatchQueue.main.async(execute: {
                    
                     Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
                })
            }
        
        }
        
        
        else {

             Server.sharedInstance.showSnackBarAlert(desc:"UserId is empty.")
            
            
            
        }
    }


    //MARK:- END
}

import UIKit
extension NSLayoutConstraint {
    /**
     Change multiplier constraint

     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
    */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {

        NSLayoutConstraint.deactivate([self])

        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)

        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier

        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
