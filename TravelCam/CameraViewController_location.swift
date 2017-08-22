//
//  CameraViewController_location.swift
//  TravelCam
//
//  Created by LEOFALCON on 2017. 8. 6..
//  Copyright © 2017년 LeFal. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

extension CameraViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if loadLocation {
            print("debug")
            CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
                if (error != nil) {
                    return
                }
                if (placemarks?.count)! > 0 {
                    let placemark = placemarks?[0]
                                        
                    self.city = ((placemark?.locality) != nil) ? (placemark?.locality)! : ""
                    self.countryCode = ((placemark?.isoCountryCode) != nil) ? (placemark?.isoCountryCode)! : ""
                    self.country = ((placemark?.country) != nil) ? (placemark?.country)! : ""
                    
                    self.mapImageView.layer.removeFromSuperlayer()
                    self.countryUILabel.layer.removeFromSuperlayer()
                    self.updateCountryLabel()
                    self.updateMapImage()
                    
                    self.languageBtnSetLocal.setTitle(self.countryCode, for: .normal)
                }
            }
            
        }
    }
    
    func updateCountryLabel() {
        self.countryUILabel.text = "\(self.country)_\(self.city)"
        self.countryUILabel.font = UIFont(name: "Helvetica Neue", size: 13)
        self.countryUILabel.textAlignment = .center
        self.countryUILabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.7).cgColor
        
        let labelWidth : CGFloat = self.countryUILabel.intrinsicContentSize.width + self.cameraView.frame.width/10
        let labelHeight : CGFloat = self.countryUILabel.intrinsicContentSize.height * 1.7
        
        let labelPointX : CGFloat = self.cameraView.frame.width/2 - labelWidth/2
        let labelPointY : CGFloat = self.cameraView.frame.height/40
    
        
        let point = CGPoint(x: labelPointX, y: labelPointY)
        let size = CGSize(width: labelWidth, height: labelHeight)
        
        self.countryUILabel.layer.cornerRadius = labelHeight/2
        
        self.countryUILabel.layer.frame = CGRect(origin: point , size: size)
        self.cameraView.layer.addSublayer(self.countryUILabel.layer)
    }
    
    func updateMapImage() {
        let mapImage = UIImage(named: self.countryCode.lowercased())
        self.mapImageView = UIImageView(image: mapImage)
        mapImageView.contentMode = .scaleAspectFill
        
        var mapImageHeightInCameraView  : CGFloat = 0
        var mapImageWidthInCameraView : CGFloat = 0
        let imageSpace : CGFloat = cameraView.frame.height/20
        
        if Float((mapImage?.size.height)!) > Float((mapImage?.size.width)!) {
            mapImageHeightInCameraView = cameraView.frame.height / 6
            mapImageWidthInCameraView = ((mapImage?.size.width)! * mapImageHeightInCameraView)/(mapImage?.size.height)!
        }else {
            mapImageWidthInCameraView = cameraView.frame.width / 6
            mapImageHeightInCameraView = ((mapImage?.size.height)! * mapImageWidthInCameraView)/(mapImage?.size.width)!
        }
        mapImageView.layer.frame = CGRect(x: cameraView.frame.width - mapImageWidthInCameraView - imageSpace, y: cameraView.frame.height - mapImageHeightInCameraView - imageSpace, width: mapImageWidthInCameraView, height: mapImageHeightInCameraView)
        self.cameraView.layer.addSublayer(mapImageView.layer)
    }
}
