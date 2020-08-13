//
//  CollectionViewController.swift
//  Richness
//
//  Created by IOS3 on 28/01/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import Foundation
import UIKit
//import PullToRefresh
import SDWebImage
import Player
import  IQKeyboardManagerSwift
import AVFoundation
import AVKit

class CollectionViewController:PanelViewController, UICollectionViewDelegate, UICollectionViewDataSource,refreshCommentCountDelegate,GetAvPlayerStatusDelegate , UICollectionViewDelegateFlowLayout , RefreshHomeDelegate{

    func commentCountDidRecieve(count: Int, tag: Int) {
        commentCount = count

        guard let cell = collectionDataview.cellForItem(at: IndexPath(row: currentIndex!, section: 0)) as? CollectionViewCell else {return}
        self.homeArray[tag].total_comments = "\(count)"
        cell.commentLabel.text = self.homeArray[tag].total_comments
        //self.tableView.reloadData()



    }


    @IBOutlet weak var collectionDataview: UICollectionView!
    @IBOutlet weak var searchBtn: UIButton!

    var profileImage = ""
    var refreshControl = UIRefreshControl()
    var start_index = 0
    var homeArray : [User] = []
    var commentsArray : [Comments] = []
    //var player = Player()
    var currentIndex :Int?
    var commentCount : Int?
    var isFristtime : Bool = false
    var selectIndex:Int = -1
    var scrollBool = Bool()
    var currentCell :CollectionViewCell?
    var isScroll = Bool()





    


    override func viewDidLoad() {
        super.viewDidLoad()

//         self.collectionDataview.decelerationRate = UIScrollViewDecelerationRateFast;
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionDataview.addSubview(refreshControl)
        getDatas()
        // setupPullToRefresh()
        //self.collectionDataview.decelerationRate = UIScrollViewDecelerationRateFast
        ProjectManager.shared.avplayerDelegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(statusBarHeightChanged), name: NSNotification.Name.UIApplicationWillChangeStatusBarFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCollection), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

      ProjectManager.shared.refreshHomeDelegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // pausePlayeVideos()
    }
   
    
    
    @objc func updateCollection() {
        if homeArray.count > 0 {
          if  collectionDataview.visibleCells.first != nil {
            guard let cell = collectionDataview.visibleCells.first as? CollectionViewCell else {
                return
            }
            if cell.playPauseBtn.currentImage == UIImage(named:"play-video1") {
                if currentIndex != nil {
                 ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: cell.videoLayer, url: (self.homeArray[currentIndex!].image))
                }
            }
            
          }
        }
    }
    
    
    
    
    @objc func statusBarHeightChanged() {
        self.collectionDataview.reloadData()
        if homeArray.count > 0{
            self.collectionDataview.scrollToItem(at:IndexPath(item:0, section: 0), at: .top, animated: true)
        }
    }
    
    
    
    
    @objc func refresh() {

        start_index = 0
        homeArray.removeAll()
        self.collectionDataview.reloadData()
        getDatas()
        refreshControl.endRefreshing()
      }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollBool = false
       // pausePlayeVideos()
      
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if currentCell != nil {
            if currentCell?.videoLayer != nil {
                currentCell?.videoLayer.player?.pause()
                ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: (currentCell?.videoLayer)!, url:  homeArray[currentIndex!].image)
            }
            
        }
    }
    
    
    
    
    //MARK:-
    //MARK:- CollectionView DataSources

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeArray.count

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            print(UIApplication.shared.statusBarFrame.height)
            if UIApplication.shared.statusBarFrame.height > 20 {
            
            return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - bottomPadding! - (UIApplication.shared.statusBarFrame.height - 20))
            } else {
                return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - bottomPadding!)
            }
        }
        else {
            if UIApplication.shared.statusBarFrame.height > 20 {
                
                return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (UIApplication.shared.statusBarFrame.height - 20))
            } else {
                 return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }
           
        }
    }





    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell

//      cell.layer.shouldRasterize = true
//      cell.layer.rasterizationScale = UIScreen.main.scale
        
        cell.infoTextView.textContainer.maximumNumberOfLines = 5
        
       // cell.videoView.layer.sublayers?.forEach{$0.removeFromSuperlayer()}
        
       


        cell.profileImg.layer.borderWidth = 1
        cell.profileImg.layer.masksToBounds = false
        cell.profileImg.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.737254902, blue: 0.5843137255, alpha: 1)
        cell.profileImg.layer.cornerRadius = cell.profileImg.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        cell.profileImg.clipsToBounds = true

        cell.sideBtn.tag = indexPath.row
        cell.sideBtn.addTarget(self,action:#selector(sidebuttonClicked),
                               for:.touchUpInside)
        cell.commentBtn.tag = indexPath.row
        cell.commentBtn.addTarget(self,action:#selector(commentbuttonClicked),
                                  for:.touchUpInside)
        cell.shareBtn.tag = indexPath.row
        cell.shareBtn.addTarget(self,action:#selector(sharebuttonClicked),
                                for:.touchUpInside)
      
       
        if homeArray.count > 0 {
             currentCell = cell
            if homeArray[indexPath.row].type == "0" {
 
                cell.playPauseBtn.isHidden = true
                cell.activityIndicator.isHidden = true
                cell.profileImageView.isHidden = false
                cell.videoView.isHidden = true
                //cell.avatarImgView.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile))
               
                
                
                
                cell.profileImageView.sd_setImage(with: URL(string : homeArray[indexPath.row].image), placeholderImage: nil, options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                    if image != nil {
                        let width: CGFloat = image!.size.width
                        let height: CGFloat = image!.size.height
                        if height > width {
                            cell.profileImageView.contentMode = .scaleAspectFill
                            cell.profileImageView.clipsToBounds = true
                        }
                            
                        else {
                            cell.profileImageView.contentMode = .scaleAspectFit
                        }
                    }
                }
                
                
                cell.profileImg.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile))
                //                cell.profileBtn.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile), for: .normal)
                cell.likesLabel.text = homeArray[indexPath.row].likes
                cell.commentLabel.text = homeArray[indexPath.row].total_comments
                cell.shareLabel.text = homeArray[indexPath.row].shares
                cell.rankingLabel.text = homeArray[indexPath.row].ranking
               // cell.profileImageView.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile))
                //                cell.profileBtn.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile), for: .normal)
                cell.videoLayer.player?.pause() //uncomment
        ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: cell.videoLayer, url:  homeArray[indexPath.row].image)
                cell.configureCell(imageUrl: "", description: "Image", videoUrl:"")

            }
            else {
                
                let videourl = (homeArray[indexPath.row].image)
                if videourl.hasPrefix("https") {
                   
                   
                   
                    //  cell.videoLayer.player?.replaceCurrentItem(with:AVPlayerItem(url:URL(string:"")!) )
                      cell.videoLayer.player?.pause()
                    //  ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: cell.videoLayer, url:  homeArray[indexPath.row].image)
//                        cell.videoLayer.backgroundColor = UIColor.clear.cgColor
//                     cell.videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                    print(cell.videoLayer.videoRect)
                   // cell.videoView.layer.addSublayer(cell.videoLayer)
                    stopActivityIndicator()
                   // cell.activityIndicator.isHidden = false
                    cell.playPauseBtn.isHidden = false
                    DispatchQueue.main.async {
                        
                        cell.playPauseBtn.setImage(#imageLiteral(resourceName: "pause-video"), for: .normal)
                        cell.playPauseBtn.setImage(#imageLiteral(resourceName: "pause-video"), for: .selected)
                        
                        cell.videoView.tag = indexPath.row
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(self.imageTapped(tapGestureRecognizer:)))
                        
                        cell.videoView.isUserInteractionEnabled = true
                        cell.videoView.addGestureRecognizer(tapGestureRecognizer)
                        
                        


                        cell.activityIndicator.isHidden = false
                        cell.activityIndicator.startAnimating()
                        
                    }
                    
                    cell.profileImageView.isHidden = true
                    cell.videoView.isHidden = false
                   

                    cell.configureCell(imageUrl: "", description: "Video", videoUrl:  homeArray[indexPath.row].image)
                        
                 
                }
                    
                else {
                    cell.activityIndicator.isHidden = true
                    cell.profileImageView.isHidden = true
                    cell.videoView.isHidden = true
                    cell.playPauseBtn.isHidden = true
                   // cell.playPauseBtn.setImage(UIImage(named: "pause-video"), for: .normal)
                }
                
                cell.profileImg.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile))
                //                cell.profileBtn.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile), for: .normal)
                cell.likesLabel.text = homeArray[indexPath.row].likes
                cell.commentLabel.text = homeArray[indexPath.row].total_comments
                cell.shareLabel.text = homeArray[indexPath.row].shares
                cell.rankingLabel.text = homeArray[indexPath.row].ranking
            }

        

            //   cell.likeLabel.text = homeArray[indexPath.row].likes + " persons"
            //  cell.nameLabel.text = homeArray[indexPath.row].name
           cell.infoTextView.text = homeArray[indexPath.row].text.decodeEmoji
            
            let size = cell.infoTextView.sizeThatFits(CGSize(width: cell.infoTextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            if size.height != cell.infoTextHeightConstarint.constant && size.height > cell.infoTextView.frame.size.height {
                cell.infoTextHeightConstarint.constant = size.height
                cell.infoTextView.setContentOffset(CGPoint.zero, animated: false)
                
                //cell.infoTextView.text = homeArray[indexPath.row].text.decodeEmoji
            }
            
            
            
//            let contentSize = cell.infoTextView.sizeThatFits(cell.infoTextView.bounds.size)
//            cell.infoTextView.frame = CGRect(x: cell.infoTextView.frame.origin.x, y: cell.infoTextView.frame.origin.y,width: contentSize.width, height: contentSize.height)



            if !(homeArray[indexPath.row].id_user == RichnessUserDefault.getUserID()) {
            
            if homeArray[indexPath.row].is_followed == 1
            {
                cell.addfollowerBtn.isHidden = true
                cell.addFollowerImage.image = UIImage(named: "")
            }

            else{
                cell.addfollowerBtn.isHidden = false
                cell.addFollowerImage.image = UIImage(named: "side_menu_option_1")

            }
                
            }
            
            else {
                
                cell.addfollowerBtn.isHidden = true
                cell.addFollowerImage.image = UIImage(named: "")
                
            }

            //   cell.likeLabel.text = homeArray[indexPath.row].likes + " persons"
            //  cell.nameLabel.text = homeArray[indexPath.row].name
            cell.infoTextView.text = homeArray[indexPath.row].text.decodeEmoji
            if(homeArray[indexPath.row].user_like == "1"){
                cell.likeButton.isChecked = true
            }
            else{
                cell.likeButton.isChecked = false
            }
            
            
            
            cell.onPlayPauseButtonTapped = {
                
                if cell.playPauseBtn.currentImage!.isEqual(UIImage(named: "pause-video")) {
                    
                    cell.playPauseBtn.setImage(UIImage(named: "play-video1"), for: .normal)
                    //self.pausePlayeVideos()
                    
                    ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: cell.videoLayer, url: (self.homeArray[indexPath.row].image))
                    
                }
                
                else {
                    cell.playPauseBtn.setImage(UIImage(named: "pause-video"), for: .normal)
                    
                    ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: cell.videoLayer, url: (self.homeArray[indexPath.row].image))
                    
                }
                
            }
            
            
            

            cell.on3DotButtonTapped = {

                (self.owner as! MainViewController).reportAlertView.isHidden = false
                (self.owner as! MainViewController).idimage = self.homeArray[indexPath.row].id

            }

            cell.onDiamondButtonTapped = {

                if cell.likeButton.isChecked {
                    self.like_unlike(like_type: 1, imageId: self.homeArray[indexPath.row].id, cell: cell, index : indexPath.row)


                }
                else{
                    self.like_unlike(like_type: 2, imageId: self.homeArray[indexPath.row].id, cell: cell, index : indexPath.row)
                }
            }

            cell.onProfileTapped = {

                self.owner?.rightToLeft()
                self.profileImage = self.homeArray[indexPath.row].image
                let nextView = mainstoryboard.instantiateViewController(withIdentifier: "ImagePreviewController") as! ImagePreviewController
                nextView.image = self.profileImage
                print(self.profileImage)
                self.owner?.present(nextView, animated: false, completion: nil)
            }

            cell.onAvatarTapped = {

                cell.videoLayer.player?.pause()
                if self.homeArray[indexPath.row].id_user == RichnessUserDefault.getUserID() {
//                    let nextView = mainstoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                     let nextView = mainstoryboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                  
                    (self.owner as! MainViewController).loadNamedView(nextView: nextView)
                    (self.owner as! MainViewController).tabButton[1].setBackgroundImage(UIImage(named: "profile"), for: .normal)
                    (self.owner as! MainViewController).tabButton[0].setBackgroundImage(UIImage(named: "home1"), for: .normal)
                }
                else{
//                    let nextView = mainstoryboard.instantiateViewController(withIdentifier: "OtherProfileViewController") as! OtherProfileViewController
                    let nextView = mainstoryboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                    RichnessUserDefault.setOtherUserID(val: self.homeArray[indexPath.row].id_user)
                    nextView.objc = self.homeArray[indexPath.row].id_user
                    let nav = UINavigationController(rootViewController:nextView )
                    self.owner?.present(nav, animated: true, completion: nil)
                }
            }

            cell.addFollowerTapped = {

                let userFollowed = self.homeArray[indexPath.row].id_user
                self.addFollowerApi(userFollowed: userFollowed, cell: cell, index : indexPath.row)

            }

//            cell.searchButtonTapped = {
//
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
//
//                vc.modalPresentationStyle = .overCurrentContext
////                vc.postId = homeArray[sender.tag].id
////                vc.tag = sender.tag
////                vc.totalCommentCount = homeArray[sender.tag].total_comments
////                vc.delegate = self
//                let nav = UINavigationController(rootViewController: vc )
//                self.present(nav, animated:true, completion:nil)
//
//
//                //self.parent?.present(vc, animated: true, completion: nil)
//
//
//
//            }

        }

        return cell

    }

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
       let cell =  collectionDataview.cellForItem(at: indexPath) as! CollectionViewCell
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        

        cell.playPauseBtn.setImage(UIImage(named: "pause-video"), for: .normal)
    
        currentIndex = indexPath.row
        if indexPath.row == homeArray.count - 1 && homeArray.count > 19  {
                  self.getDatas()
        }
       
       
        


      //  pausePlayeVideos()


    }



    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {


        
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
          
           
//            if !(ASVideoPlayerController.sharedVideoPlayer.mute){
//                // Pause the player
//               // pausePlayeVideos()
//                ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: videoCell.videoLayer, url: videoCell.videoURL!)
//
//            }
            
         
            
                
         
            
          // pausePlayeVideos()
                ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
           //  cell.videoLayer.removeFromSuperlayer()
            
        
              //  self.pausePlayeVideos()
                
            
            

            
        }

    }
    
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pausePlayeVideos()
        
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
       
        let tag = (tapGestureRecognizer.view)?.tag
        let indexPath = NSIndexPath(row: tag!, section: 0)
        
        let cell = self.collectionDataview.cellForItem(at: indexPath as IndexPath) as! CollectionViewCell
        
        if  cell.playPauseBtn.isHidden {
            cell.playPauseBtn.isHidden = false
        }
        else {
            cell.playPauseBtn.isHidden = true
        }
        
    }

    @objc func sidebuttonClicked(sender: UIButton) {
        //        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath as IndexPath) as! homeCell
        //
        //        cell.sideView.frame = CGRect(x: cell.sideView.frame.origin.x , y: cell.sideView.frame.origin.y, width: cell.sideView.frame.size.width, height: cell.sideView.frame.size.height)

      let indexPath = NSIndexPath(row: sender.tag, section: 0)
        //let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! CollectionViewCell

       let cell = self.collectionDataview.cellForItem(at: indexPath as IndexPath) as? CollectionViewCell

        if cell!.sideviewTrailingConstraint.constant == -87
        {

            cell!.sideviewTrailingConstraint.constant = -1
            cell!.sideBtn.setImage(UIImage(named: ""), for: UIControlState.normal)
        }

        else

        {
            cell!.sideviewTrailingConstraint.constant = -87 //-79

        }

    }

    @objc func commentbuttonClicked(sender: UIButton) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController

        vc.modalPresentationStyle = .overCurrentContext
        vc.postId = homeArray[sender.tag].id
        vc.tag = sender.tag
        vc.totalCommentCount = homeArray[sender.tag].total_comments
        vc.delegate = self
        self.parent?.present(vc, animated: true, completion: nil)
        //        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        //        let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! homeCell
        //
        //        let post_id = homeArray[indexPath.row].id
        //        getCommentsApi(postId: post_id)
 }

    @objc func sharebuttonClicked(sender: UIButton) {
        let url = URL(string:homeArray[sender.tag].image)
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)

    }


    


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       
        pausePlayeVideos()
       
        
        if !scrollBool {
            scrollBool = true
        }
        else {
            for i in collectionDataview.visibleCells {
                let indxpath = collectionDataview.indexPath(for:i)
            
                if let cell = i as? CollectionViewCell {
                    cell.playPauseBtn.setImage(#imageLiteral(resourceName: "pause-video"), for: .normal)
                    cell.sideviewTrailingConstraint.constant = -87
            
                }
                
                
                
            }
        }
        
//        var visibleRect = CGRect()
//
//        visibleRect.origin = collectionDataview.contentOffset
//        visibleRect.size = collectionDataview.bounds.size
//
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//
//        guard let indexPath = collectionDataview.indexPathForItem(at: visiblePoint)else { return }
//
//        let cell = collectionDataview.cellForItem(at: indexPath) as? CollectionViewCell
//         cell?.playPauseBtn.setImage(#imageLiteral(resourceName: "pause-video"), for: .normal)
        
//        print(indexPath)

    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
        if !decelerate {
            pausePlayeVideos()
        }

    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }



    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideossFor(collectionView: collectionDataview)
    }

    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideossFor(collectionView: collectionDataview, appEnteredFromBackground: true)
    }

    func getDatas() {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)

        let params = [
            "start_index" : self.start_index,
            "user_id" : RichnessUserDefault.getUserID(),
            "key" : key
            ] as [String : Any]
        print(params)

        start_index += 1

        RichnessAlamofire.POST(GETTIMELINE_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
                // self.tableView.endRefreshing(at: .bottom)
                if(responseObject.object(forKey: "result") != nil){
                    let result = responseObject.object(forKey: "result") as? [NSDictionary]

                    for item in result!{

                        let usermodel = User()

                        usermodel.id = item["id"] as? String ?? ""
                        if (usermodel.id == ""){
                            usermodel.id = String(describing: item["id"] as? Int)
                        }

                        usermodel.country = item["country"] as? String ?? ""
                        usermodel.description = item["description"] as? String ?? ""
                        usermodel.id_user = item["id_user"] as? String ?? ""
                        usermodel.image = item["image"] as? String ?? ""
                        usermodel.image_profile = item["image_profile"] as? String ?? ""
                        usermodel.likes = item["likes"] as? String ?? ""
                        usermodel.name = item["name"] as? String ?? ""
                        usermodel.ranking = item["ranking"] as? String ?? ""
                        usermodel.total_comments = item["total_comments"] as? String ?? ""
                        usermodel.shares = item["shares"] as? String ?? ""
                        usermodel.text = item["text"] as? String ?? ""
                        print(item["text"] as? String ?? "")
                        usermodel.user_like = item["user_like"] as? String ?? ""
                        usermodel.type = item["type"] as? String ?? ""
                        usermodel.is_followed = item["is_followed"] as? Int ?? 0

                        self.homeArray.append(usermodel)

                    }
                    DispatchQueue.main.async {
                        self.collectionDataview.reloadData()
                    }
                }
            }
            else
            {
                let error = responseObject.object(forKey: "error") as? String
                if (error == "#997") {
                    self.showError(errMsg: user_error_unknown)
                }
                else {
                    self.showError(errMsg: error_on_server)
                }
            }
        }
    }

    func like_unlike(like_type : Int, imageId : String, cell : CollectionViewCell, index : Int) {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)

        let params = [
            "liked_type" : like_type,
            "image_id" : imageId,
            "user_id" : RichnessUserDefault.getUserID(),
            "key" : key


            ] as [String : Any]
        print(params)

        RichnessAlamofire.POST(ADDLIKE_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){

                if(responseObject.object(forKey: "like_add") != nil){
                    if(like_type == 1){

                        self.homeArray[index].likes = String(Int(self.homeArray[index].likes)! + 1)
                        cell.likesLabel.text = self.homeArray[index].likes //+ " persons"
                    }
                    else{
                        self.homeArray[index].likes = String(Int(self.homeArray[index].likes)! - 1)
                        cell.likesLabel.text = self.homeArray[index].likes //+ " persons"

                    }
                }
            }
            else
            {
                let error = responseObject.object(forKey: "error") as? String
                if (error == "#997") {
                    self.showError(errMsg: user_error_unknown)
                }
                else {
                    self.showError(errMsg: error_on_server)
                }
            }
        }
    }


    func addFollowerApi(userFollowed: String, cell : CollectionViewCell, index : Int)
    {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)

        let params = [
            "user_id" : RichnessUserDefault.getUserID(),
            "user_followed": userFollowed ,
            "key" : key
            ] as [String : Any]
        print(params)

        RichnessAlamofire.POST(ADDFOLLOWRES_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){


                cell.addFollowerImage.image = UIImage(named: "")
                cell.addfollowerBtn.isHidden = true
                self.homeArray[index].is_followed = 1
            }
            else
            {
                let error = responseObject.object(forKey: "error") as? String
                if (error == "#997") {
                    self.showError(errMsg: user_error_unknown)
                }
                else {
                    self.showError(errMsg: error_on_server)
                }
            }
        }
    }
    
  
    
    @IBAction func searchBtnAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        //                vc.postId = homeArray[sender.tag].id
        //                vc.tag = sender.tag
        //                vc.totalCommentCount = homeArray[sender.tag].total_comments
        //                vc.delegate = self
        let nav = UINavigationController(rootViewController: vc )
        self.present(nav, animated:true, completion:nil)
        
    }
    

    func stopActivityIndicator() {
        if currentIndex != nil {
            guard let cell = collectionDataview.cellForItem(at: IndexPath(row: currentIndex!, section: 0)) as? CollectionViewCell
                else {return}
            
            //DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
            //}
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
