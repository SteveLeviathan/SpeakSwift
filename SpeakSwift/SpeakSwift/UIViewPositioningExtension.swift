//
//  UIViewPositioningExtension.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 18-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    
    
    /// Position this view below other view
    func positionBelowView(_ view : UIView, xOffset: CGFloat, yOffset: CGFloat) {
        
        self.frame = CGRect(x: view.frame.minX + xOffset, y: view.frame.maxY + yOffset, width: self.frame.width, height: self.frame.height)
        
    }
    
    
    /// Position this view below other view with an absolute x-position
    func positionBelowView(_ view : UIView, absoluteX: CGFloat, yOffset: CGFloat) {
        
        self.frame = CGRect(x: absoluteX, y: view.frame.maxY + yOffset, width: self.frame.width, height: self.frame.height)
        
    }
    
    
    /// Position this view above other view
    func positionAboveView(_ view : UIView, xOffset: CGFloat, yOffset: CGFloat) {
        
        self.frame = CGRect(x: view.frame.minX + xOffset, y: view.frame.minY - self.frame.height + yOffset, width: self.frame.width, height: self.frame.height)
        
    }
    
    
    /// Position this view above other view with an absolute x-position
    func positionAboveView(_ view : UIView, absoluteX: CGFloat, yOffset: CGFloat) {
        
        self.frame = CGRect(x: absoluteX, y: view.frame.minY - self.frame.height + yOffset, width: self.frame.width, height: self.frame.height)
        
    }
    
    
    /// Position this view right from other view
    func positionRightFromView(_ view : UIView, xOffset: CGFloat, yOffset: CGFloat) {
        
        self.frame = CGRect(x: view.frame.maxX + xOffset, y: view.frame.minY + yOffset, width: self.frame.width, height: self.frame.height)
        
    }
    
    
    /// Position this view right from other view with an absolute y-position
    func positionRightFromView(_ view : UIView, xOffset: CGFloat, absoluteY: CGFloat) {
        
        self.frame = CGRect(x: view.frame.maxX + xOffset, y: absoluteY, width: self.frame.width, height: self.frame.height)
        
    }
    
    
    /// Position this view left from other view
    func positionLeftFromView(_ view : UIView, xOffset: CGFloat, yOffset: CGFloat) {
        
        self.frame = CGRect(x: view.frame.minX - self.frame.width + xOffset, y: view.frame.minY + yOffset, width: self.frame.width, height: self.frame.height)
        
    }
    
    
    /// Position this view left from other view with an absolute y-position
    func positionLeftFromView(_ view : UIView, xOffset: CGFloat, absoluteY: CGFloat) {
        
        self.frame = CGRect(x: view.frame.minX - self.frame.width + xOffset, y: absoluteY, width: self.frame.width, height: self.frame.height)
        
    }
    
}
