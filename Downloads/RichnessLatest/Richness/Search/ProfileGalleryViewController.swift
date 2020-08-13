//
//  ProfileGalleryViewController.swift
//  Richness
//
//  Created by IOS3 on 11/02/19.
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

class ProfileGalleryViewController: PanelViewController, UICollectionViewDelegate, UICollectionViewDataSource,refreshCommentCountDelegate,GetAvPlayerStatusDelegate , UICollectionViewDelegateFlowLayout {

    func commentCountDidRecieve(count: Int, tag: Int)
    {
        commentCount = count

        guard let cell = collectionDataview.cellForItem(at: IndexPath(row: currentIndex!, section: 0)) as? ProfileGalleryCollectionViewCell else {return}
        self.homeArray[tag].total_comments = "\(count)"
        cell.commentLabel.text = self.homeArray[tag].total_comments
        //self.tableView.reloadData()



    }


    @IBOutlet weak var collectionDataview: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!

    var profileImage = ""
    var refreshControl = UIRefreshControl()
    var start_index = Int()
    var homeArray: [User] = []
    var commentsArray : [Comments] = []
    var player = Player()
    var currentIndex :Int?
    var commentCount : Int?
    var cellIndex = Int()
    var user_ID = String()
    var hashTagName = String()
    var boolHashRecived = Bool()
    var boolSent = true
    var scrollBool = Bool()
    var currentCell:ProfileGalleryCollectionViewCell?



    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.collectionDataview.decelerationRate = UIScrollViewDecelerationRateFast;
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionDataview.addSubview(refreshControl)
        //getDatas()
        collectionDataview.reloadData()
       // collectionDataview.scrollToItem(at: IndexPath(row: cellIndex, section: 0), at: .centeredVertically , animated: false)

        // setupPullToRefresh()
        self.collectionDataview.decelerationRate = UIScrollViewDecelerationRateFast
        ProjectManager.shared.avplayerDelegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)



        // Do any additional setup after loading the view.
       NotificationCenter.default.addObserver(self, selector: #selector(statusBarHeightChanged), name: NSNotification.Name.UIApplicationWillChangeStatusBarFrame, object: nil)
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCollection), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func updateCollection() {
        if homeArray.count > 0 {
            if  collectionDataview.visibleCells.first != nil {
                guard let cell = collectionDataview.visibleCells.first as? ProfileGalleryCollectionViewCell else {
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
        collectionDataview.reloadData()
        getDatas()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollBool = false
        DispatchQueue.main.async {
            self.collectionDataview.scrollToItem(at: IndexPath(row: self.cellIndex, section: 0), at: .centeredVertically , animated: false)
            self.pausePlayeVideos()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        DispatchQueue.main.async {
//            self.collectionDataview.scrollToItem(at: IndexPath(row: self.cellIndex, section: 0), at: .centeredVertically , animated: false)
//            self.pausePlayeVideos()
//
//        }
       
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
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if currentIndex != nil {
//        if currentIndex == cellIndex {
//            self.pausePlayeVideos()
//        }
//        }
//    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if currentIndex != nil {
            if currentIndex == cellIndex {
                self.pausePlayeVideos()
            }
        }
    }
    //MARK:-
    //MARK:- CollectionView DataSources

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeArray.count

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            if UIApplication.shared.statusBarFrame.height > 20 {
                
                return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (UIApplication.shared.statusBarFrame.height - 20))
            } else {
                return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height )
            }
       
    }





    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileGalleryCollectionViewCell", for: indexPath) as! ProfileGalleryCollectionViewCell

        cell.infoTextView.textContainer.maximumNumberOfLines = 5
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
                //cell.profileImageView.sd_setImage(with: URL(string : homeArray[indexPath.row].image))
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
                if homeArray[indexPath.row].total_comments == "" {
                    cell.commentLabel.text = "0"
                }
                else {
                    cell.commentLabel.text = homeArray[indexPath.row].total_comments
                }
                cell.shareLabel.text = homeArray[indexPath.row].shares
                cell.rankingLabel.text = homeArray[indexPath.row].ranking
                // cell.profileImageView.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile))
                //                cell.profileBtn.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile), for: .normal)
                cell.videoLayer.player?.pause()
                ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: cell.videoLayer, url:  homeArray[indexPath.row].image)
                cell.configureCell(imageUrl: "", description: "Image", videoUrl:"")

            } else {
                
                //  cell.videoLayer.player?.replaceCurrentItem(with:AVPlayerItem(url:URL(string:"")!) )
                //  cell.videoLayer.player?.pause()
                //  ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: cell.videoLayer, url:  homeArray[indexPath.row].image)
                let videourl = (homeArray[indexPath.row].image)
                if videourl.hasPrefix("https") {
                    cell.videoLayer.backgroundColor = UIColor.clear.cgColor
                    cell.videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                    cell.videoView.layer.addSublayer(cell.videoLayer)
                    cell.playPauseBtn.isHidden = false
                   // cell.activityIndicator.isHidden = false
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
            

//            cell.backButtonTapped = {
//                self.dismiss(animated: true, completion: nil)
//            }

            cell.on3DotButtonTapped = {

//                (self.owner as! MainViewController).reportAlertView.isHidden = false
//                (self.owner as! MainViewController).idimage = self.homeArray[indexPath.row].id

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

//                self.owner?.rightToLeft()
//                self.profileImage = self.homeArray[indexPath.row].image
//                let nextView = mainstoryboard.instantiateViewController(withIdentifier: "ImagePreviewController") as! ImagePreviewController
//                nextView.image = self.profileImage
//                print(self.profileImage)
//                self.owner?.present(nextView, animated: false, completion: nil)
            }

            cell.onAvatarTapped = {

                cell.videoLayer.player?.pause()
                if self.homeArray[indexPath.row].id_user == RichnessUserDefault.getUserID() {
                    let nextView = mainstoryboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                    nextView.boolRecived = self.boolSent
                    let nav = UINavigationController(rootViewController: nextView)
                    self.present(nav, animated: true, completion: nil)
//                    (self.owner as! MainViewController).loadNamedView(nextView: nextView)
//                    (self.owner as! MainViewController).tabButton[1].setBackgroundImage(UIImage(named: "profile"), for: .normal)
//                    (self.owner as! MainViewController).tabButton[0].setBackgroundImage(UIImage(named: "home1"), for: .normal)

                }
                else{
                    let nextView = mainstoryboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                    RichnessUserDefault.setOtherUserID(val: self.homeArray[indexPath.row].id_user)
                    nextView.objc = self.homeArray[indexPath.row].id_user
                    let nav = UINavigationController(rootViewController: nextView)
                    self.present(nav, animated: true, completion: nil)
                    //self.owner?.present(nextView, animated: true, completion: nil)
                }
            }

            cell.addFollowerTapped = {

                let userFollowed = self.homeArray[indexPath.row].id_user
                self.addFollowerApi(userFollowed: userFollowed, cell: cell, index : indexPath.row)

            }
        }

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileGalleryCollectionViewCell", for: indexPath) as! ProfileGalleryCollectionViewCell
        currentIndex = indexPath.row
        
        if indexPath.row == homeArray.count - 1 && homeArray.count > 19
        {
            self.start_index += 1
            self.getDatas()

        }


        //  pausePlayeVideos()


    }



    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        //       if let cell =  collectionDataview.cellForItem(at: indexPath) as? CollectionViewCell {
        //        ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: cell.videoLayer, url:  homeArray[indexPath.row].image)
        //        }
        //
        //        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
        //            videoCell.videoLayer.player = nil
        //             videoCell.videoLayer.player?.pause()
        //            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        //        } else {
        //
        //        }


        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }

    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let tag = (tapGestureRecognizer.view)?.tag
        let indexPath = NSIndexPath(row: tag!, section: 0)
        
        let cell = self.collectionDataview.cellForItem(at: indexPath as IndexPath) as! ProfileGalleryCollectionViewCell
        
        if  cell.playPauseBtn.isHidden {
            cell.playPauseBtn.isHidden = false
        }
        else {
            cell.playPauseBtn.isHidden = true
        }
        
    }

    @objc func sidebuttonClicked(sender: UIButton)
    {
        //        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath as IndexPath) as! homeCell
        //
        //        cell.sideView.frame = CGRect(x: cell.sideView.frame.origin.x , y: cell.sideView.frame.origin.y, width: cell.sideView.frame.size.width, height: cell.sideView.frame.size.height)

        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        //let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! CollectionViewCell

        let cell = self.collectionDataview.cellForItem(at: indexPath as IndexPath) as? ProfileGalleryCollectionViewCell

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

    @objc func commentbuttonClicked(sender: UIButton)
    {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController

        vc.modalPresentationStyle = .overCurrentContext
        vc.postId = homeArray[sender.tag].id
        vc.tag = sender.tag
        vc.totalCommentCount = homeArray[sender.tag].total_comments
        vc.delegate = self
       self.present(vc, animated: true, completion: nil)
        //        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        //        let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! homeCell
        //
        //        let post_id = homeArray[indexPath.row].id
        //        getCommentsApi(postId: post_id)




    }

    @objc func sharebuttonClicked(sender: UIButton)
    {
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
                //let indxpath = collectionDataview.indexPath(for:i)
                if let cell = i as? ProfileGalleryCollectionViewCell {
                    cell.playPauseBtn.setImage(#imageLiteral(resourceName: "pause-video"), for: .normal)
                    cell.sideviewTrailingConstraint.constant = -87
                    //                cell.activityIndicator.stopAnimating()
                    //                cell.activityIndicator.isHidden = true
                }
                
            }
            
        }

    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
        }

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
        var user_Id = String()
        if user_ID == RichnessUserDefault.getUserID() {
           user_Id = RichnessUserDefault.getUserID()
        }
        else {
            user_Id = user_ID

        }

        var params = [String: Any]()

//        if boolHashRecived == true {
//            params = [
//                "start_index" : self.start_index,
//                "user_id" : RichnessUserDefault.getUserID(),
//                "id" :  user_Id,
//                "hashtag": hashTagName ,
//                "key" : key
//            ] //as [String : Any]
//
//        }
//
//        else {

            params = [
                "start_index" : self.start_index,
                "user_id" : RichnessUserDefault.getUserID(),
                "id" :  user_Id,
                "key" : key
            ] //as [String : Any]
       // }

        print(params)

        //start_index += 1

        RichnessAlamofire.POST(GETTIMELINE_URL, parameters: params as [String : AnyObject],showLoading: false,showSuccess: false,showError: false
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
                        //                        UIView.performWithoutAnimation {
                        //                            self.tableView.reloadData()
                        //                            self.tableView.layoutIfNeeded()
                        //                            self.tableView.beginUpdates()
                        //                            self.tableView.endUpdates()
                        //                        }
                        self.collectionDataview.reloadData()
                        //                        self.collectionDataview.performBatchUpdates({
                        //
                        //                        }, completion: { (status) in
                        //                            self.updateTableViewContentInset()
                        //
                        //                        })
                        //                        let lastContentOffset = self.tableView.contentOffset
                        //                        self.tableView.beginUpdates()
                        //                        self.tableView.endUpdates()
                        //                        self.tableView.layer.removeAllAnimations()
                        //                        self.tableView.setContentOffset(lastContentOffset, animated: false)


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

    func like_unlike(like_type : Int, imageId : String, cell : ProfileGalleryCollectionViewCell, index : Int) {

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


    func addFollowerApi(userFollowed: String, cell : ProfileGalleryCollectionViewCell, index : Int)
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
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func stopActivityIndicator() {
        if currentIndex != nil {
            guard let cell = collectionDataview.cellForItem(at: IndexPath(row: currentIndex!, section: 0)) as? ProfileGalleryCollectionViewCell
                else {return}
            
            //DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
                
           // }
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
