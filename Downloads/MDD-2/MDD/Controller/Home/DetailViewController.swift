//
//  DetailViewController.swift
//  MDD
//
//  Created by iOS6 on 04/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import PopupDialog
import Alamofire

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, downloadFileDelegate {
    
    func showCompletionMsg() {
        
         Server.sharedInstance.showSnackBarAlert(desc:"File Downloaded Successfully.")
        
    }
   
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    var itemsArray = ["MDD\nBriefing","CAT\nOverview","Observations\n/Insights",
                     "Latest\nUpdates", "Hire\nMDD","Contact\nUs"]
    var covidItemsArray = ["MDD\nBriefing","CAT\nOverview","Hire\nMDD",
                     "Recent\nTweets"]
    
    
    var itemsImageArray =  [#imageLiteral(resourceName: "MDD-breifing"), #imageLiteral(resourceName: "CAT-overview"), #imageLiteral(resourceName: "observation"), #imageLiteral(resourceName: "lates-update"), #imageLiteral(resourceName: "hire-mdd"), #imageLiteral(resourceName: "contact-now")]
    var covidItemsImageArray =  [#imageLiteral(resourceName: "MDD-breifing"), #imageLiteral(resourceName: "CAT-overview"),#imageLiteral(resourceName: "hire-mdd"), #imageLiteral(resourceName: "recent-tweet")]

    var obj = CategoryObjectModel()
    var pdfLink = String()
    var notificationId = String()
    var notificationTitle = String()
    var checkNotification = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()

        Server.sharedInstance.downlaodDelegate = self

        if checkNotification {
            
            titleLabel.text = notificationTitle
            obj.cat_id = notificationId
            obj.cat_name = notificationTitle
        }
        else {
            titleLabel.text = obj.cat_name
        }
        // Do any additional setup after loading the view.
    }
    
    
    //Mark:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK:-
    //MARK:- CollectionView DataSources
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (detailCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if obj.isCovid == "Yes" {
            
            return covidItemsArray.count
            
        } else {
        
        return itemsArray.count
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        
        cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 10)
        
        if obj.isCovid == "Yes" {
            
                cell.cellLabel.text = covidItemsArray[indexPath.row]
                cell.cellImgView.image = covidItemsImageArray[indexPath.row]
            
        } else {

        cell.cellLabel.text = itemsArray[indexPath.row]
        cell.cellImgView.image = itemsImageArray[indexPath.row]
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if obj.isCovid == "Yes" {
            
            switch indexPath.row {
            case 0:
                
                mddBriefingApi()
              
                
            case 1:
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CATOverviewViewController") as! CATOverviewViewController
                 vc.objc = obj
                self.present(vc, animated: true, completion: nil)
                
            case 2:
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HireMDDViewController") as! HireMDDViewController
                
                vc.checkBool = true
                self.present(vc, animated: true, completion: nil)

            case 3:
                
               let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentTweetsViewController") as! RecentTweetsViewController
                
                vc.obj = obj
                vc.tweetBool = true
                self.present(vc, animated: true, completion: nil)

            default:
              
                print(indexPath.row)
            }
            
            
            
        } else {
        
        switch indexPath.row {
        case 0:
            
            mddBriefingApi()
          
            
        case 1:
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CATOverviewViewController") as! CATOverviewViewController
             vc.objc = obj
            self.present(vc, animated: true, completion: nil)

        case 2:
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ObservationsViewController") as! ObservationsViewController
            
            vc.objc = obj
            self.present(vc, animated: true, completion: nil)
            

        case 3:
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LatestUpdatesViewController") as! LatestUpdatesViewController
            
            vc.objc = obj
            self.present(vc, animated: true, completion: nil)
            
        case 4:
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HireMDDViewController") as! HireMDDViewController
            
            vc.checkBool = true
            self.present(vc, animated: true, completion: nil)
            
            
        case 5:
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            
            vc.obj = obj
            
            self.present(vc, animated: true, completion: nil)

        default:
          
            print(indexPath.row)
        }
            
     }
        
    }
 
    //MARK:-
    //MARK:- API Methods
    
    func mddBriefingApi()
    {
        
        
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
            
            let params = ["user_id":userId!, "cat_id": obj.cat_id] as [String: Any]
            print(params)
            
            if Server.sharedInstance.isInternetAvailable()
            {
                
                DispatchQueue.main.async {
                    
                    Server.sharedInstance.showNewLoader(vc: self)
                    
                }
                
                Alamofire.request(K_Base_Url+K_MddBriefing_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
                        let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json as NSDictionary)
                        let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                        if status.boolValue {
                            
                            
                            if let response = json["repsonse"] as? [String: Any]  {
                                
                                let desc = response["description"] as? String
                                self.pdfLink = (response["pdf_link"] as? String)!
                                
                                
                                if self.pdfLink == "" {

                                    Server.sharedInstance.showSnackBarAlert(desc: "No file to show")
                                    
                                }
                                    
                                else {
                                    
                                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentTweetsViewController") as! RecentTweetsViewController
                                    
                                    vc.briefingObjc = self.pdfLink
                                    vc.briefingBool = true
                                    self.present(vc, animated: true, completion: nil)

                                }
                            }
                            
                            
                        }
                        else {
                            
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
    
    
    func downloadFileFromURL()  {
        
        
        if Server.sharedInstance.isInternetAvailable() {
            
            self.downloadPopup()
            
            let fileUrl =  pdfLink // /\(obj.UserID)
            Alamofire.request(fileUrl, headers:nil).downloadProgress { (progress) in
                NotificationCenter.default.post(name:.downloadProgress, object:progress )
                print(progress.fractionCompleted , progress.fileTotalCount , progress.fileCompletedCount , progress.totalUnitCount )
                }.responseData { (data) in
                    Server.sharedInstance.stopLoader()
                    
                    if let contentType = data.response?.allHeaderFields["Content-Type"] as? String {
                        print("contentType ***** \(contentType)")
                        
                        
                        let filePath = self.documentsPathForFileName(name: "\(Date().ticks)" + "MddBriefing.pdf")
                        
                        // Server.sharedInstance.showSnackBarAlert(desc:"File Downloaded Successfully.")
                        
                        do {
                            
                            try data.data?.write(to:filePath!)
                            
                        }
                        catch {
                            
                            
                        }
                        
                    }
                    
            }
            
        }
        else {
            Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
            
        }
        
    }
    
    func documentsPathForFileName(name: String) -> URL? {
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        let fileURL = dirPaths[0].appendingPathComponent(name)
        return fileURL
    }
    func downloadPopup() {
        
        let alertVC :DownloadingPopup = (self.storyboard?.instantiateViewController(withIdentifier: "DownloadingPopup") as? DownloadingPopup)!
        let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
        ,tapGestureDismissal: false, panGestureDismissal: false) {
            let overlayAppearance = PopupDialogOverlayView.appearance()
            overlayAppearance.blurRadius  = 30
            overlayAppearance.blurEnabled = true
            overlayAppearance.liveBlur    = false
            overlayAppearance.opacity     = 0.4
        }
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
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
