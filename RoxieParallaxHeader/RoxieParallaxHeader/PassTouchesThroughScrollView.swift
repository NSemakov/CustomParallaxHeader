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

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool
    {
        var result = false
        
        if let headerView = self.firstViewOfClass(HeaderView.self) {
            result = headerView.point(inside: point, with: event)
        }
        
        return result
    }
}

