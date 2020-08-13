//
//  Splash1ViewController.swift
//  Richness
//
//  Created by Sobura on 6/6/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit

let mainstoryboard = UIStoryboard(name: "Main", bundle: nil)

class Splash1ViewController: UIViewController {
    
    var nextTimer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        DispatchQueue.main.async {
           self.navigationController?.navigationBar.isHidden = true            
        }
    }
    
    
    func startTimer()
    {
        print("Timer Started")
        self.nextTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(Splash1ViewController.nextStep), userInfo: nil, repeats: false)
    }
    
    func stopTimer()
    {
        if(self.nextTimer != nil)
        {
            self.nextTimer.invalidate()
            self.nextTimer = nil
            print("Timer Stopped")
        }
    }
    @objc func nextStep()
    {
        stopTimer()
        self.rightToLeft()
        let nextView = mainstoryboard.instantiateViewController(withIdentifier: "Splash2ViewController") as! Splash2ViewController
        self.present(nextView, animated: false, completion: nil)
    }
}
