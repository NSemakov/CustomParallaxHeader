// ----------------------------------------------------------------------------
//
//  UIImage+MDAdditions.swift
//
//  @author     Vasily Ivanov <IvanovVF@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
import UIKit

// ----------------------------------------------------------------------------

extension UIImage
{

// MARK: - Functions

    static func stretchableImageNamed(_ name: String, leftCapWidth: Int, topCapHeight: Int) -> UIImage? {
        return UIImage(named: name)?.stretchableImage(withLeftCapWidth: leftCapWidth, topCapHeight: topCapHeight)
    }
    
    static func imageWithColor(_ color: UIColor) -> UIImage?
    {
        var result: UIImage?

        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        
        result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func imageByApplyingAlpha(_ alpha: Float) -> UIImage?
    {
        var result: UIImage?

        // How to set the opacity/alpha of a UIImage?
        // @link http://stackoverflow.com/a/10819117
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        if let context = UIGraphicsGetCurrentContext()
        {
            let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -area.size.height)
            context.setBlendMode(.multiply)
            context.setAlpha(CGFloat(alpha))
            context.draw(self.cgImage!, in: area)
        }
        
        result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func getPixelColor(_ pos: CGPoint) -> UIColor?
    {
        guard let cgImage = self.cgImage,
              let provider = cgImage.dataProvider else
        {
            return nil
        }
        
        let pixelData = provider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

// ----------------------------------------------------------------------------
