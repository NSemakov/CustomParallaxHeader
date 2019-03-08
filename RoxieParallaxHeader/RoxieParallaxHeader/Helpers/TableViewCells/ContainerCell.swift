// ----------------------------------------------------------------------------
//
//  ContainerCell.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2015, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

// TODO: Code refactoring is needed.
// - Add invalidateContentSize() method and call it in each subclass on content change.
// - Remove KVO observing.

// ----------------------------------------------------------------------------

class ContainerCell: AutoLayoutCell
{
// MARK: - Construction

    deinit {
        removeObserversFromContainedView()
    }

// MARK: - Properties

    var containedView: UIView? {
        get {
            return self.contentView.subviews.first
        }
        set {
            // Remove observes from old contained view
            removeObserversFromContainedView()

            // Remove all subviews
            self.contentView.removeSubviews()

            if let subview = newValue
            {
                // Add new subview
                self.contentView.addSubview(subview)

                // Add constraints
                subview.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)

                // Add observers
                addObserversToContainedView()
            }
        }
    }

// MARK: - Methods

    override func heightForTableView(_ tableView: UITableView) -> CGFloat
    {
        if self.hiddenCell
        {
            // Hide cell
            return 0
        }

        // use correct width to calculate content size
        self.bounds = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: self.bounds.height)
        layoutIfNeeded()

        // calculate cell size using container content size
        let size = contentSize()

        // return height
        return size.height
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (context == &Inner.KVOContext)
        {
            if let parentTableView = self.parentTableView
            {
                if let scrollView = (object as? UIScrollView)
                {
                    let oldContentSize = (change![NSKeyValueChangeKey.oldKey]! as AnyObject).cgSizeValue
                    let newContentSize = scrollView.contentSize
                    if !(oldContentSize?.equalTo(newContentSize))!
                    {
                        parentTableView.beginUpdates()
                        parentTableView.endUpdates()
                    }
                }
                else
                if let subview = (object as? UIView)
                {
                    let oldFrame = (change![NSKeyValueChangeKey.oldKey]! as AnyObject).cgRectValue
                    let newFrame = subview.frame
                    if !(oldFrame?.equalTo(newFrame))!
                    {
                        parentTableView.beginUpdates()
                        parentTableView.endUpdates()
                    }
                }
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

// MARK: - Private Methods

    private func contentSize() -> CGSize
    {
        // Calculate size
        var contentSize = CGSize.zero

        if let tableView = (self.containedView as? UITableView)
        {
            // Force table view to calculate content size
            tableView.layoutIfNeeded()

            contentSize = tableView.contentSize
        }
        else
        if let scrollView = (self.containedView as? UIScrollView)
        {
            contentSize = scrollView.contentSize
        }
        else
        {
            contentSize = self.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        }

        // Done
        return contentSize
    }

    private func addObserversToContainedView()
    {
        if let containedView = self.containedView, !(self.observerExists)
        {
            if let scrollView = (containedView as? UIScrollView)
            {
                scrollView.isScrollEnabled = false
                scrollView.addObserver(self, forKeyPath: "contentSize", options: .old, context: &Inner.KVOContext)
            }
            else
            {
                containedView.addObserver(self, forKeyPath: "frame",  options: .old, context: &Inner.KVOContext)
                containedView.addObserver(self, forKeyPath: "bounds", options: .old, context: &Inner.KVOContext)
            }

            self.observerExists = true
        }
    }

    private func removeObserversFromContainedView()
    {
        if let containedView = self.containedView, self.observerExists
        {
            if let scrollView = (containedView as? UIScrollView)
            {
                scrollView.removeObserver(self, forKeyPath: "contentSize", context: &Inner.KVOContext)
            }
            else
            {
                containedView.removeObserver(self, forKeyPath: "frame",  context: &Inner.KVOContext)
                containedView.removeObserver(self, forKeyPath: "bounds", context: &Inner.KVOContext)
            }
        }

        self.observerExists = false
    }

// MARK: - Constants

    private struct Inner {
        static var KVOContext = "ContainerCell-KVOContext"
    }

// MARK: - Variables

    private var observerExists = false

}

// ----------------------------------------------------------------------------
