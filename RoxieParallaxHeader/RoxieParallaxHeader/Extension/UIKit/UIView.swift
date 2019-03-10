// ----------------------------------------------------------------------------
//
//  UIView.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import SwiftCommonsLang
import UIKit

// ----------------------------------------------------------------------------

extension UIView
{
// MARK: - Construction

    class func loadFromNib(_ nibName: String? = nil, nibBundle: Bundle? = nil, owner: AnyObject? = nil, options: [UINib.OptionsKey : Any]? = nil) -> Self
    {
        let nibName = nibName ?? defaultResourceName
        let nibBundle = nibBundle ?? Bundle.main

        let bundleItems = UINib(nibName: nibName, bundle: nibBundle).instantiate(withOwner: owner, options: options)

        if let firstView = (bundleItems.first as? UIView),
           let view = Roxie.conditionalCast(firstView, to: self)
        {
            return view
        }
        else {
            fatalError("Expected nib named '\(nibName)' to contains view with class '\(self)'.")
        }
    }

// MARK: - Properties

    class var defaultResourceName: String {
        return Roxie.typeName(of: self)
    }

// MARK: - Methods

    func removeSubviews()
    {
        for subview in (self.subviews as [UIView]) {
            subview.removeFromSuperview()
        }
    }

    func firstParentOfClass<V>(_ clazz: V.Type) -> V?
    {
        if let view = (self as? V) {
            return view
        }

        return self.superview?.firstParentOfClass(clazz)
    }

    func firstViewOfClass<V>(_ clazz: V.Type) -> V?
    {
        if let view = (self as? V) {
            return view
        }

        for child in self.subviews
        {
            if let view = child.firstViewOfClass(clazz) {
                return view
            }
        }

        return nil
    }

}

// ----------------------------------------------------------------------------
