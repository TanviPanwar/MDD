//
//  VideoPlayerController.swift
//  AutoPlayVideo
//
//  Created by Ashish Singh on 12/3/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

import UIKit
import AVFoundation
 //let player = AVPlayer()
/**
 Protocol that needs to be adopted by subclass of any UIView
 that wants to play video.
 */
protocol ASAutoPlayVideoLayerContainer {
    var videoURL: String? { get set }
    var videoLayer: AVPlayerLayer { get set }
    func visibleVideoHeight() -> CGFloat
}

class ASVideoPlayerController: NSObject, NSCacheDelegate {
    var minimumLayerHeightToPlay: CGFloat = 60
    // Mute unmute video
    var mute = false
    var preferredPeakBitRate: Double = 1000000
    static private var playerViewControllerKVOContext = 0
    static let sharedVideoPlayer = ASVideoPlayerController()
    //video url for currently playing video
    private var videoURL: String?
    /**
     Stores video url as key and true as value when player item associated to the url
     is being observed for its status change.
     Helps in removing observers for player items that are not being played.
     */
    private var observingURLs = Dictionary<String, Bool>()
    // Cache of player and player item
    private var videoCache = NSCache<NSString, ASVideoContainer>()
    private var videoLayers = VideoLayers()
    // Current AVPlapyerLayer that is playing video
    private var currentLayer: AVPlayerLayer?
    
    override init() {
        super.init()
        videoCache.delegate = self
    }
    
    /**
     Download of an asset of url if corresponding videocontainer
     is not present.
     Uses the asset to create new playeritem.
     */
    func setupVideoFor(url: String) {
        if self.videoCache.object(forKey: url as NSString) != nil {
            return
        }
        guard let URL = URL(string: url) else {
            return
        }
        let asset = AVURLAsset(url: URL)
        let requestedKeys = ["playable"]
        asset.loadValuesAsynchronously(forKeys: requestedKeys) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            /**
             Need to check whether asset loaded successfully, if not successful then don't create
             AVPlayer and AVPlayerItem and return without caching the videocontainer,
             so that, the assets can be tried to be downloaded again when need be.
             */
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
                case .loaded:
                    break
                case .failed, .cancelled:
                    print("Failed to load asset successfully")
                    return
                default:
                    print("Unkown state of asset")
                    return
            }
            let player = AVPlayer()
            let item = AVPlayerItem(asset: asset)
            DispatchQueue.main.async {
                let videoContainer = ASVideoContainer(player: player, item: item, url: url)
                strongSelf.videoCache.setObject(videoContainer, forKey: url as NSString)
                videoContainer.player.replaceCurrentItem(with: videoContainer.playerItem)
                /**
                 Try to play video again in case when playvideo method was called and
                 asset was not obtained, so, earlier video must have not run
                 */
                if strongSelf.videoURL == url, let layer = strongSelf.currentLayer {
                    strongSelf.playVideo(withLayer: layer, url: url)
                }
            }
        }
    }
    // Play video with the AVPlayerLayer provided
    func playVideo(withLayer layer: AVPlayerLayer, url: String) {
        videoURL = url
        currentLayer = layer
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            layer.player = videoContainer.player
            videoContainer.playOn = true
            addObservers(url: url, videoContainer: videoContainer)
        }
        // Give chance for current video player to be ready to play
        DispatchQueue.main.async {
            if let videoContainer = self.videoCache.object(forKey: url as NSString),
                videoContainer.player.currentItem?.status == .readyToPlay  {
               
//                NotificationCenter.default.post(name:Notification.Name(rawValue: "PlayVideo"), object:nil, userInfo:nil)
                videoContainer.playOn = true
                 ProjectManager.shared.avplayerDelegate?.stopActivityIndicator()
                
                
            }
        }
    }
    
     func pauseVideo(forLayer layer: AVPlayerLayer, url: String) {
        videoURL = nil
        currentLayer = nil
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            videoContainer.playOn = false
          
        
            //videoContainer.play = false
            removeObserverFor(url: url)
        }
    }
    
    func removeLayerFor(cell: ASAutoPlayVideoLayerContainer) {
        if let url = cell.videoURL {
            removeFromSuperLayer(layer: cell.videoLayer, url: url)
        }
    }
    
    private func removeFromSuperLayer(layer: AVPlayerLayer, url: String) {
        videoURL = nil
        currentLayer = nil
       
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            videoContainer.playOn = false
           
            
            removeObserverFor(url: url)
        }
        layer.player = nil
    }
    
    private func pauseRemoveLayer(layer: AVPlayerLayer,url: String, layerHeight: CGFloat) {
        pauseVideo(forLayer: layer, url: url)
    }
    
    // Play video again in case the current player has finished playing
    @objc func playerDidFinishPlaying(note: NSNotification) {
        guard let playerItem = note.object as? AVPlayerItem,
            let currentPlayer = currentVideoContainer()?.player else {
                return
        }
        if let currentItem = currentPlayer.currentItem, currentItem == playerItem {
            currentPlayer.seek(to: kCMTimeZero)
            currentPlayer.play()
        }
    }
    
    private func currentVideoContainer() -> ASVideoContainer? {
        if let currentVideoUrl = videoURL {
            if let videoContainer = videoCache.object(forKey: currentVideoUrl as NSString) {
                return videoContainer
            }
        }
        return nil
    }
    
    private func addObservers(url: String, videoContainer: ASVideoContainer) {
        if self.observingURLs[url] == false || self.observingURLs[url] == nil {
            videoContainer.player.currentItem?.addObserver(self,
                                                           forKeyPath: "status",
                                                           options: [.new, .initial],
                                                           context: &ASVideoPlayerController.playerViewControllerKVOContext)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerDidFinishPlaying(note:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: videoContainer.player.currentItem)
            
            self.observingURLs[url] = true
        }
    }
    
    
    private func removeObserverFor(url: String) {
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            if let currentItem = videoContainer.player.currentItem, observingURLs[url] == true {
                currentItem.removeObserver(self,
                                           forKeyPath: "status",
                                           context: &ASVideoPlayerController.playerViewControllerKVOContext)
                NotificationCenter.default.removeObserver(self,
                                                          name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                          object: currentItem)
                observingURLs[url] = false
            }
        }
    }
    
    /**
     Play UITableViewCell's videoplayer that has max visible video layer height
     when the scroll stops.
     */

    func pausePlayeVideossFor(collectionView: UICollectionView, appEnteredFromBackground: Bool = false) {
        let visisbleCells = collectionView.visibleCells
        var videoCellContainer: ASAutoPlayVideoLayerContainer?
        var maxHeight: CGFloat = 0.0
        for cellView in visisbleCells {
            guard let containerCell = cellView as? ASAutoPlayVideoLayerContainer,
                let videoCellURL = containerCell.videoURL else {
                    continue
            }
            let height = containerCell.visibleVideoHeight()
            if maxHeight < height {
                maxHeight = height
                videoCellContainer = containerCell
            }
            pauseRemoveLayer(layer: containerCell.videoLayer, url: videoCellURL, layerHeight: height)
        }
        guard let videoCell = videoCellContainer,
            let videoCellURL = videoCell.videoURL else {
                return
        }
        let minCellLayerHeight = videoCell.videoLayer.bounds.size.height * 0.5
        /**
         Visible video layer height should be at least more than max of predefined minimum height and
         cell's videolayer's 50% height to play video.
         */
        let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
        if maxHeight > minimumVideoLayerVisibleHeight {
            if appEnteredFromBackground {
                setupVideoFor(url: videoCellURL)
            }
            playVideo(withLayer: videoCell.videoLayer, url: videoCellURL)
        }
    }



    func pausePlayeVideosFor(tableView: UITableView, appEnteredFromBackground: Bool = false) {
        let visisbleCells = tableView.visibleCells
        var videoCellContainer: ASAutoPlayVideoLayerContainer?
        var maxHeight: CGFloat = 0.0
        for cellView in visisbleCells {
            guard let containerCell = cellView as? ASAutoPlayVideoLayerContainer,
                let videoCellURL = containerCell.videoURL else {
                    continue
            }
            let height = containerCell.visibleVideoHeight()
            if maxHeight < height {
                maxHeight = height
                videoCellContainer = containerCell
            }
            pauseRemoveLayer(layer: containerCell.videoLayer, url: videoCellURL, layerHeight: height)
        }
        guard let videoCell = videoCellContainer,
            let videoCellURL = videoCell.videoURL else {
            return
        }
        let minCellLayerHeight = videoCell.videoLayer.bounds.size.height * 0.5
        /**
         Visible video layer height should be at least more than max of predefined minimum height and
         cell's videolayer's 50% height to play video.
         */
        let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
        if maxHeight > minimumVideoLayerVisibleHeight {
            if appEnteredFromBackground {
                setupVideoFor(url: videoCellURL)
            }
            playVideo(withLayer: videoCell.videoLayer, url: videoCellURL)
        }
    }
    
    // Set observing urls false when objects are removed from cache
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let videoObject = obj as? ASVideoContainer {
            observingURLs[videoObject.url] = false
        }
    }
    
    // Play video only when current videourl's player is ready to play
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        // Make sure the this KVO callback was intended for this view controller.
        guard context == &ASVideoPlayerController.playerViewControllerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if keyPath == "status" {
            /**
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            let newStatus: AVPlayerItemStatus
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
                if newStatus == .readyToPlay {

                    guard let item = object as? AVPlayerItem,
                        let currentItem = currentVideoContainer()?.player.currentItem else {
                            return
                    }
                    if item == currentItem && currentVideoContainer()?.playOn == true {
                        currentVideoContainer()?.playOn = true
                        ProjectManager.shared.avplayerDelegate?.stopActivityIndicator()
                    }
                }
            }
            else {
                newStatus = .unknown
            }
            if newStatus == .failed {
                
            }
        }
    }
    
    deinit {
        
    }
}



protocol GetAvPlayerStatusDelegate {
    func stopActivityIndicator()  
}
protocol PostVideoDelegate {
    func navigateToHome()
}
protocol RefreshHomeDelegate {
    func refresh()
}
import SDWebImage

class ProjectManager:NSObject  {
   var postVideoDelegate :PostVideoDelegate?
    var avplayerDelegate :GetAvPlayerStatusDelegate?
     var refreshHomeDelegate :RefreshHomeDelegate?
    static let shared = ProjectManager()
    private override init() {

    }
    func getImage(urlStr:String, completion:@escaping(UIImage?)->Void) {
        
        DispatchQueue.global(qos:.background).async {
            do {
                let data = try Data(contentsOf: URL(string: urlStr)!)
                let img = UIImage(data:data)
             
                DispatchQueue.main.async {
                    completion(img)
                }
                
            }
            catch {
                DispatchQueue.main.async {
                    completion(UIImage())
                }
            }
            
        }
        
        //            SDImageCache.shared().queryCacheOperation(forKey: urlStr, done: { (image, data, type) in
        //                if let image = image {
        //                     DispatchQueue.main.async {
        //                    completion(image)
        //                    }
        //                } else {
        //                    if let url = URL(string: urlStr) {
        //                        SDWebImageManager.shared().loadImage(with: url, options: [.scaleDownLargeImages], progress: nil) { (image, data, error, type, done, url) in
        //                           DispatchQueue.global(qos:.background).async {
        //                            let width = (UIScreen.main.bounds.size.width - 2)/3
        //                            let img = image?.resizeImageWith(newSize: CGSize(width: width, height: width + 60))
        ////                                if let data =  image?.jpeg(.lowest) {
        //                                     SDImageCache.shared().store(img, forKey: urlStr, completion: nil)
        //                                    DispatchQueue.main.async {
        //                                        completion(img)
        //
        //
        //
        //                                    }
        //
        //
        //
        ////                            }
        //                            }
        //                        }
        //
        //                    } else {
        //                        DispatchQueue.main.async {
        //                            completion(nil)
        //
        //
        //                        }
        //
        //                    }
        //                }
        //            })
        
        
    }
    func getImageFromSDWebimage(urlStr:String, completion:@escaping(UIImage?)->Void) {
        
          DispatchQueue.global(qos:.background).async {
            do {
            let data = try Data(contentsOf: URL(string: urlStr)!)
            let img = UIImage(data:data)
            let width = (UIScreen.main.bounds.size.width - 2)/3
            let image = img?.resizeImageWith(newSize: CGSize(width: width, height: width + 60))
                DispatchQueue.main.async {
                    completion(image)
                }
                
            }
            catch {
                DispatchQueue.main.async {
                    completion(UIImage())
                }
            }
            
          }
       
//            SDImageCache.shared().queryCacheOperation(forKey: urlStr, done: { (image, data, type) in
//                if let image = image {
//                     DispatchQueue.main.async {
//                    completion(image)
//                    }
//                } else {
//                    if let url = URL(string: urlStr) {
//                        SDWebImageManager.shared().loadImage(with: url, options: [.scaleDownLargeImages], progress: nil) { (image, data, error, type, done, url) in
//                           DispatchQueue.global(qos:.background).async {
//                            let width = (UIScreen.main.bounds.size.width - 2)/3
//                            let img = image?.resizeImageWith(newSize: CGSize(width: width, height: width + 60))
////                                if let data =  image?.jpeg(.lowest) {
//                                     SDImageCache.shared().store(img, forKey: urlStr, completion: nil)
//                                    DispatchQueue.main.async {
//                                        completion(img)
//                                       
//                                        
//                                        
//                                    }
//                                   
//                                    
//                               
////                            }
//                            }
//                        }
//                        
//                    } else {
//                        DispatchQueue.main.async {
//                            completion(nil)
//                            
//                            
//                        }
//                        
//                    }
//                }
//            })
        
        
    }
    
    func getThumnailImageFromVideo(urlStr:String , completion:@escaping(UIImage?)->Void) {
        DispatchQueue.global(qos:.background).async {
            
            let asset = AVAsset(url: URL(string: urlStr)!)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            //Can set this to improve performance if target size is known before hand
            let width = (UIScreen.main.bounds.size.width - 2)/3
            //assetImgGenerate.maximumSize = CGSize(width: width, height: width + 60)
            let time = CMTimeMakeWithSeconds(1.0, 600)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                if img != nil {
                    let thumbnail = UIImage(cgImage: img)
//                    if  let data = thumbnail.jpeg(.lowest) {
//                    let image = UIImage(cgImage: img).resizeImageWith(newSize: CGSize(width: width, height: width + 60))
                        DispatchQueue.main.async {
                           // let image = UIImage(data: data)
                            completion(thumbnail)
                           
                        }
//                    }
                }
                
            } catch {
                
                DispatchQueue.main.async {
                   print(error.localizedDescription)
                 completion(nil)
                }
                
            }
            
        }
        
    }

}
extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
