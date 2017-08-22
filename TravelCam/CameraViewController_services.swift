//
//  CameraViewController_services.swift
//  TravelCam
//
//  Created by LEOFALCON on 2017. 8. 6..
//  Copyright © 2017년 LeFal. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

extension CameraViewController {
    
    @IBAction func activateFlash(_ sender: Any) {
        if captureDevice!.hasTorch {
            do {
                try captureDevice!.lockForConfiguration()
                captureDevice?.torchMode = captureDevice!.isTorchActive ? .off : .on
                
                captureDevice!.unlockForConfiguration()
            } catch { }
        }
    }
    @IBAction func setLanguage(_ sender: Any) {
        flashBtn.isHidden = true
        latticeBtn.isHidden = true
        
        languageBtnSetDevice.isHidden = false
        languageBtnSetEnglish.isHidden = false
        languageBtnSetLocal.isHidden = false
    }
    
    @IBAction func setLanguageToDevice(_ sender: Any) {
        self.changeLanguage(to: .device)
        self.languageBtn.setTitle(Locale.current.regionCode!, for: .normal)
        
//        self.languageBtnSetDevice.isHighlighted = true
//        self.languageBtnSetEnglish.isHighlighted = false
//        self.languageBtnSetLocal.isHighlighted = false
//        
        self.updateCountryLabel()
        hiddenLanguageButton()
    }
    
    @IBAction func setLanguageToEnglish(_ sender: Any) {
        self.changeLanguage(to: .English)
        self.languageBtn.setTitle("EN", for: .normal)

//        self.languageBtnSetDevice.isHighlighted = false
//        self.languageBtnSetEnglish.isHighlighted = true
//        self.languageBtnSetLocal.isHighlighted = false
        
        self.updateCountryLabel()
        hiddenLanguageButton()
    }
    
    @IBAction func setLanguageToLocale(_ sender: Any) {
        self.changeLanguage(to: .local)
        self.languageBtn.setTitle(self.countryCode, for: .normal)
        
//        self.languageBtnSetDevice.isHighlighted = false
//        self.languageBtnSetEnglish.isHighlighted = false
//        self.languageBtnSetLocal.isHighlighted = true
        
        self.updateCountryLabel()
        hiddenLanguageButton()
    }
    
    func hiddenLanguageButton() {
        flashBtn.isHidden = false
        latticeBtn.isHidden = false
        
        languageBtnSetDevice.isHidden = true
        languageBtnSetEnglish.isHidden = true
        languageBtnSetLocal.isHidden = true

    }
    
    func changeLanguage(to language : Language) {
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = self
        
        
        
        UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        switch language {
        case .device:
            //UserDe.setCurrentLanguage("ko")
            break
        case .English:
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        case .local :
            UserDefaults.standard.set([self.countryCode.lowercased()], forKey: "AppleLanguages")
        }
        UserDefaults.standard.synchronize()
    }
}

