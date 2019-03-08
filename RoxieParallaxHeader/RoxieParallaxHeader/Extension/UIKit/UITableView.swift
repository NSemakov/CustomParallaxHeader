// ----------------------------------------------------------------------------
//
//  UITableView.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2015, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

extension UITableView
{
// MARK: - Methods

    func sizeHeaderToFit()
    {
        if let headerView = self.tableHeaderView
        {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()

            let size = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            headerView.height = size.height

            self.tableHeaderView = headerView
        }
    }

    func sizeFooterToFit()
    {
        if let footerView = self.tableFooterView
        {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()

            let size = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            footerView.height = size.height

            self.tableFooterView = footerView
        }
    }

    func registerCellClass<T: UITableViewCell>(_ aClass: T.Type)
    {
        let nib = UINib(nibName: aClass.defaultResourceName, bundle: nil)
        register(nib, forCellReuseIdentifier: aClass.defaultReusableIdentifier)
    }

    func dequeueReusableCellOfClass<T: UITableViewCell>(_ aClass: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: aClass.defaultReusableIdentifier) as! T
    }

    func dequeueReusableCellOfClass<T: UITableViewCell>(_ aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: aClass.defaultReusableIdentifier, for: indexPath) as! T
    }

    func registerHeaderFooterViewClass<T: UITableViewHeaderFooterView>(_ aClass: T.Type)
    {
        let nib = UINib(nibName: aClass.defaultResourceName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: aClass.defaultReusableIdentifier)
    }

    func dequeueReusableHeaderFooterViewOfClass<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: aClass.defaultResourceName) as! T
    }

}

// ----------------------------------------------------------------------------
