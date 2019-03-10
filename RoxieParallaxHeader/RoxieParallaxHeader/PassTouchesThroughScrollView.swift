// ----------------------------------------------------------------------------
//
//  PassTouchesThroughScrollView.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2018, Roxie Mobile Ltd. All rights reserved.
//  @link       http://www.roxiemobile.ru/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

class PassTouchesThroughScrollView: UIScrollView
{
// MARK: - Methods
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
    {
        var result: UIView? = nil

        if let headerView = self.firstViewOfClass(HeaderView.self), headerView.point(inside: point, with: event) {
            result = headerView.hitTest(point, with: event)
        }
        
        return result
    }
}

// ----------------------------------------------------------------------------
