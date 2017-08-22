//
//  CameraViewController_camera.swift
//  TravelCam
//
//  Created by LEOFALCON on 2017. 8. 6..
//  Copyright © 2017년 LeFal. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

extension CameraViewController {
    func beginSession(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        self.cameraView.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.cameraView.layer.bounds
        
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureSession.startRunning()
        stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
    }
    
    func frontCamera(_ front : Bool)  {
        let devices = AVCaptureDevice.devices()
        
        do {
            try captureSession.removeInput(AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print("error")
        }
        
        for device in devices! {
            if (device as AnyObject).hasMediaType(AVMediaTypeVideo) {
                if front {
                    if (device as AnyObject).position == AVCaptureDevicePosition.front {
                        captureDevice = device as? AVCaptureDevice
                        
                        do {
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                        }catch {
                            
                        }
                        break
                    }
                } else {
                    if (device as AnyObject).position == AVCaptureDevicePosition.back {
                        captureDevice = device as? AVCaptureDevice
                        
                        do {
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                        }catch {
                            
                        }
                        break
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let screenSize = cameraView.bounds.size
        if let touchPoint = touches.first {
            let x = touchPoint.location(in: cameraView).y / screenSize.height
            let y = 1.0 - touchPoint.location(in: cameraView).x / screenSize.width
            let focusPoint = CGPoint(x: x, y: y)
            
            if let device = captureDevice {
                do {
                    try device.lockForConfiguration()
                    
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = .continuousAutoFocus
                    device.focusMode = .autoFocus
                    device.focusMode = .locked
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureExposureMode.continuousAutoExposure
                    device.unlockForConfiguration()
                }
                catch {
                    // just ignore
                }
            }
        }
    }

    @IBAction func captureCamera(_ sender: Any) {
        locationManager.startUpdatingLocation()

        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataSampleBuffer, error)in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let image = UIImage(data: imageData!)
                print("image taked : \(image!)")
                
                
                let cropImage = ImageService.cropImageToSquare(image: image!)
                
                ImageService.merge(image: cropImage!, mapImage: self.mapImageView.image!, cameraViewLabel: self.countryUILabel, cameraViewWidth: self.cameraView.frame.width)
                
                
                print("image croped : \(cropImage!)")
                
                self.cameraView.backgroundColor = UIColor(patternImage: image!)
            })
        }
    }
    
    
    @IBAction func changeCamera(_ sender: Any) {
        frontCamera = !frontCamera
        captureSession.beginConfiguration()
        let inputs = captureSession.inputs as! [AVCaptureInput]
        for oldInput : AVCaptureInput in inputs {
            captureSession.removeInput(oldInput)
        }
        frontCamera(frontCamera)
        
        captureSession.commitConfiguration()
    }

    func addCameraFilter() {

        let filterLayer = CALayer()
        filterLayer.
        
        filterLayer.frame = CGRect(x: 0, y: 0, width: cameraView.frame.width, height: cameraView.frame.height)
        self.cameraView.layer.addSublayer(filterLayer)

    }
}
