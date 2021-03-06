//
//  ImageService.swift
//  TravelCam
//
//  Created by LEOFALCON on 2017. 8. 5..
//  Copyright © 2017년 LeFal. All rights reserved.
//

import Foundation
import UIKit
import CoreImage



class ImageService  {
    static func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }
        
        return nil
    }
    
    static func merge(image : UIImage, mapImage : UIImage, cameraViewLabel : UILabel, cameraViewWidth : CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContext(image.size)
        let imageAreaSize = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        image.draw(in: imageAreaSize)
    
        // merge map
        
        var mapImageWidthInCameraView : CGFloat = 0
        var mapImageHeightInCameraView  : CGFloat = 0
        
        let imageSpace : CGFloat = image.size.height/20
        
        if Float((mapImage.size.height)) > Float((mapImage.size.width)) {
            mapImageHeightInCameraView = image.size.height / 6
            mapImageWidthInCameraView = ((mapImage.size.width) * mapImageHeightInCameraView)/(mapImage.size.height)
        }else {
            mapImageWidthInCameraView = image.size.width / 6
            mapImageHeightInCameraView = ((mapImage.size.height) * mapImageWidthInCameraView)/(mapImage.size.width)
        }
        let mapRect = CGRect(x: image.size.width - mapImageWidthInCameraView - imageSpace, y: image.size.height - mapImageHeightInCameraView - imageSpace, width: mapImageWidthInCameraView, height: mapImageHeightInCameraView)

        mapImage.draw(in: mapRect)

        // merge label
        
        let label = UILabel()
        label.text = cameraViewLabel.text
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 13 * image.size.width/cameraViewWidth)
        label.layer.backgroundColor = UIColor.white.cgColor

        let labelWidth : CGFloat = label.intrinsicContentSize.width * 1.5
        let labelHeight : CGFloat = label.intrinsicContentSize.height * 1.5
        let labelPointX : CGFloat = image.size.width/2 - labelWidth/2
        let labelPointY : CGFloat = image.size.height/40
        let labelRect = CGRect(x: labelPointX, y: labelPointY, width: labelWidth, height: labelHeight)
        
        label.frame = labelRect
        
        label.layer.cornerRadius = labelHeight/2
        let labelImage = UIImage.imageWithLabel(label: label)

       // UIImageWriteToSavedPhotosAlbum(labelImage, nil, nil, nil)
        
        labelImage.draw(in: labelRect)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
        
        return newImage
    }
    

    
}

extension UIImage {
    class func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
