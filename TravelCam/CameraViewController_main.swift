//
//  CameraViewController.swift
//  CustomCameraPractice
//
//  Created by LEOFALCON on 2017. 8. 4..
//  Copyright © 2017년 LeFal. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class CameraViewController: UIViewController {

    let locationManager = CLLocationManager()
    var loadLocation : Bool = true
    
    var countryCode : String = ""
    var city : String = ""
    var country : String = ""
    let countryUILabel = UILabel()
    var mapImageView = UIImageView()
    
    @IBOutlet var cameraView: UIView!
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var frontCamera : Bool = false
    var stillImageOutput : AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    
    @IBOutlet var flashBtn: UIButton!

    @IBOutlet var languageBtn: UIButton!
    
    @IBOutlet var languageBtnSetDevice: UIButton!
    @IBOutlet var languageBtnSetEnglish: UIButton!
    @IBOutlet var languageBtnSetLocal: UIButton!
    
    @IBOutlet var latticeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        self.view.backgroundColor = .black
        captureSession.sessionPreset  = AVCaptureSessionPresetPhoto
        frontCamera(frontCamera)
        if captureDevice != nil {
            beginSession()
        }
        
        self.languageBtn.setTitle(Locale.current.regionCode!, for: .normal)
        self.languageBtnSetDevice.setTitle(Locale.current.regionCode!, for: .normal)
        self.languageBtnSetEnglish.setTitle("EN", for: .normal)
        
        languageBtnSetDevice.isHidden = true
        languageBtnSetEnglish.isHidden = true
        languageBtnSetLocal.isHidden = true
    }
}



