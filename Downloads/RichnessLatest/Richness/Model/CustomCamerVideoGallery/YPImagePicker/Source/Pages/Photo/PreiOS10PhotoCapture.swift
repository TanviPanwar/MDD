//
//  PreiOS10PhotoCapture.swift
//  YPImagePicker
//
//  Created by Sacha DSO on 08/03/2018.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class PreiOS10PhotoCapture: YPPhotoCapture {

    let sessionQueue = DispatchQueue(label: "YPCameraVCSerialQueue", qos: .background)
    let session = AVCaptureSession()
    var deviceInput: AVCaptureDeviceInput?
    var device: AVCaptureDevice? { return deviceInput?.device }
    private let imageOutput = AVCaptureStillImageOutput()
    var output: AVCaptureOutput { return imageOutput }
    var isCaptureSessionSetup: Bool = false
    var isPreviewSetup: Bool = false
    var previewView: UIView!
    var videoLayer: AVCaptureVideoPreviewLayer!
    var currentFlashMode: YPFlashMode = .off
    private let v = YPCameraView(overlayView: nil)
    let photoCapture = newPhotoCapture()

    var hasFlash: Bool {
        guard let device = device else { return false }
        return device.hasFlash
    }
    
    // MARK: - Configuration
    
    func configure() { }
    
    // MARK: - Flash
    
    func tryToggleFlash() {
        guard let device = device else { return }
        guard device.hasFlash else { return }
        do {
            try device.lockForConfiguration()
            switch device.flashMode {
            case .auto:
                currentFlashMode = .on
                device.flashMode = .on
//                let flashImage = photoCapture.currentFlashMode.flashImage()
//                v.flashButton.setImage(flashImage, for: .normal)
                //v.flashLabel.text = "On"
            case .on:
                currentFlashMode = .off
                device.flashMode = .off
//                let flashImage = photoCapture.currentFlashMode.flashImage()
//                v.flashButton.setImage(flashImage, for: .normal)
                //v.flashLabel.text = "Off"




            case .off:
                currentFlashMode = .auto
                device.flashMode = .auto
//                let flashImage = photoCapture.currentFlashMode.flashImage()
//                v.flashButton.setImage(flashImage, for: .normal)
                //v.flashLabel.text = "Auto"



            }
            device.unlockForConfiguration()
        } catch _ { }
    }
    
    // MARK: - Shoot
    
    func shoot(completion: @escaping (Data) -> Void) {
        DispatchQueue.global(qos: .default).async {
            self.setCurrentOrienation()
            if let connection = self.output.connection(with: .video) {
                self.imageOutput.captureStillImageAsynchronously(from: connection) { buffer, _ in
                    if let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer!) {
                        completion(data)
                    }
                }
            }
        }
    }
}
