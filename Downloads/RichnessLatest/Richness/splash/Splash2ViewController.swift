//
//  Splash2ViewController.swift
//  Richness
//
//  Created by Sobura on 6/6/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit

class Splash2ViewController: UIViewController {
    
    var nextTimer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }
    
    func startTimer()
    {
        print("Timer Started")
        self.nextTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(Splash1ViewController.nextStep), userInfo: nil, repeats: false)
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
        let nextView = mainstoryboard.instantiateViewController(withIdentifier: "Splash3ViewController") as! Splash3ViewController
        self.present(nextView, animated: false, completion: nil)
    }
}
