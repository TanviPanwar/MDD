//
//  LatestUpdatesViewController.swift
//  MDD
//
//  Created by iOS6 on 19/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class LatestUpdatesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var latestUpdateCollectionView: UICollectionView!
    
    var itemsArray = ["News\nFeed","Weather\nLinks","Recent\nTweets"]
    var covidItemsArray = ["Recent\nTweets"]

    
    var itemsImageArray =  [#imageLiteral(resourceName: "news-feed"), #imageLiteral(resourceName: "weather-links"), #imageLiteral(resourceName: "recent-tweet")]
    var covidItemsImageArray =  [ #imageLiteral(resourceName: "recent-tweet")]

    var objc = CategoryObjectModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //MARK:-
    //MARK:- CollectionView DataSources
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (latestUpdateCollectionView.frame.size.width - space) / 2.0
        // let height : CGFloat = (detailCollectionView.frame.size.height - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if objc.isCovid == "Yes" {
            return covidItemsArray.count
            
        } else {
       
            return itemsArray.count
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        
        cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 10)
        
        if objc.isCovid == "Yes" {
            
            cell.cellLabel.text = covidItemsArray[indexPath.row]
                   cell.cellImgView.image = covidItemsImageArray[indexPath.row]
            
        } else {
        
        cell.cellLabel.text = itemsArray[indexPath.row]
        cell.cellImgView.image = itemsImageArray[indexPath.row]
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if objc.isCovid == "Yes" {
            
            switch indexPath.row {

            case 0:
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentTweetsViewController") as! RecentTweetsViewController
                
                vc.obj = objc
                vc.tweetBool = true
                self.present(vc, animated: true, completion: nil)
                
            default:
                
                print(indexPath.row)
            }
            
            
        } else {
        
        switch indexPath.row {
        case 0:
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsFeedCollectionViewController") as! NewsFeedCollectionViewController
            
            vc.objc = objc
            self.present(vc, animated: true, completion: nil)
            
        case 1:
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherLinksViewController") as! WeatherLinksViewController
            
            vc.objc = objc
            self.present(vc, animated: true, completion: nil)
            
        case 2:
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentTweetsViewController") as! RecentTweetsViewController
            
            vc.obj = objc
            vc.tweetBool = true
            self.present(vc, animated: true, completion: nil)
            
        default:
            
            print(indexPath.row)
        }
            
     }
        
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
