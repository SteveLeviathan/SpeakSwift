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
    func positionBelowView(view : UIView, xOffset: CGFloat, yOffset: CGFloat) {
        
        self.frame = CGRect(x: CGRectGetMinX(view.frame) + xOffset, y: CGRectGetMaxY(view.frame) + yOffset, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame))
        
    }
    
    
    /// Position this view below other view with an absolute x-position
    func positionBelowView(view : UIView, absoluteX: CGFloat, yOffset: CGFloat) {
        
        self.frame = CGRect(x: absoluteX, y: CGRectGetMaxY(view.frame) + yOffset, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame))
        
    }
    
    
    /// Position this view above other view
    func positionAboveView(view : UIView, xOffset: CGFloat, yOffset: CGFloat) {
        
        self.frame = CGRect(x: CGRectGetMinX(view.frame) + xOffset, y: CGRectGetMinY(view.frame) - CGRectGetHeight(self.frame) + yOffset, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame))
        
    }
    
    
    /// Position this view above other view with an absolute x-position
    func positionAboveView(view : UIView, absoluteX: CGFloat, yOffset: CGFloat) {
        
        self.frame = CGRect(x: absoluteX, y: CGRectGetMinY(view.frame) - CGRectGetHeight(self.frame) + yOffset, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame))
        
    }
    
    
    /// Position this view right from other view
    func positionRightFromView(view : UIView, xOffset: CGFloat, yOffset: CGFloat) {
        
        self.frame = CGRect(x: CGRectGetMaxX(view.frame) + xOffset, y: CGRectGetMinY(view.frame) + yOffset, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame))
        
    }
    
    
    /// Position this view right from other view with an absolute y-position
    func positionRightFromView(view : UIView, xOffset: CGFloat, absoluteY: CGFloat) {
        
        self.frame = CGRect(x: CGRectGetMaxX(view.frame) + xOffset, y: absoluteY, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame))
        
    }
    
    
    /// Position this view left from other view
    func positionLeftFromView(view : UIView, xOffset: CGFloat, yOffset: CGFloat) {
        
        self.frame = CGRect(x: CGRectGetMinX(view.frame) - CGRectGetWidth(self.frame) + xOffset, y: CGRectGetMinY(view.frame) + yOffset, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame))
        
    }
    
    
    /// Position this view left from other view with an absolute y-position
    func positionLeftFromView(view : UIView, xOffset: CGFloat, absoluteY: CGFloat) {
        
        self.frame = CGRect(x: CGRectGetMinX(view.frame) - CGRectGetWidth(self.frame) + xOffset, y: absoluteY, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame))
        
    }
    
}