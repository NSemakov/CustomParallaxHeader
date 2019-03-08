// ----------------------------------------------------------------------------
//
//  AutoLayoutTableViewHelper.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2015, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

class AutoLayoutTableViewHelper: NSObject
{
// MARK: - Construction

    init(tableView: UITableView, dataSource: AutoLayoutTableViewDataSource, delegate: AutoLayoutTableViewDelegate)
    {
        // Init instance variables
        self.tableView = tableView
        self.dataSource = dataSource
        self.delegate = delegate

        // Parent processing
        super.init()
    }

// MARK: - Properties

    unowned let tableView: UITableView

    unowned let dataSource: AutoLayoutTableViewDataSource

    unowned let delegate: AutoLayoutTableViewDelegate

    weak var scrollViewDelegate: UIScrollViewDelegate?

    var useHeaderRefreshControl: Bool = false { didSet { updateHeaderRefreshControl() } }

// MARK: - Methods

    func registerCellClass(_ cellClass: AutoLayoutCell.Type)
    {
        let resourceName = cellClass.defaultResourceName
        let cellNib = UINib(nibName: resourceName, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellClass.defaultReusableIdentifier)
    }

    func beginRefreshing() {
        self.headerRefreshControl.beginRefreshing()
    }

    func endRefreshing() {
        self.headerRefreshControl.endRefreshing()
    }

// MARK: - Actions

    @IBAction
    func refresh(_ sender: Any) {
        self.delegate.didRefresh()
    }

// MARK: - Private Methods

    private func updateHeaderRefreshControl()
    {
        if self.useHeaderRefreshControl
        {
            if (self.headerRefreshControl.superview == nil)
            {
                // Add refresh control to table view
                self.headerRefreshControl.addTarget(self, action: #selector(AutoLayoutTableViewHelper.refresh(_:)), for: .valueChanged)
                self.tableView.insertSubview(self.headerRefreshControl, at: 0)
            }
        }
        else
        {
            if (self.headerRefreshControl.superview != nil)
            {
                // Remove refresh control from table view
                self.headerRefreshControl.removeTarget(self, action: #selector(AutoLayoutTableViewHelper.refresh(_:)), for: .valueChanged)
                self.headerRefreshControl.removeFromSuperview()
            }
        }
    }

// MARK: - Inner Types

    private struct Inner {
        static let TableFooterBottomTreshold: CGFloat = 30.0
    }

// MARK: - Constants

    // ...

// MARK: - Variables

    private let headerRefreshControl = RefreshControl()

    private var prototypeCells: [String: AutoLayoutCell] = [:]

    private var prototypeHeaderFooterViews: [String: UITableViewHeaderFooterView] = [:]

}

// ----------------------------------------------------------------------------
// MARK: - @protocol UITableViewDelegate
// ----------------------------------------------------------------------------

extension AutoLayoutTableViewHelper: UITableViewDelegate
{
// MARK: - Methods

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cellClass = self.dataSource.cellClassForIndexPath(indexPath)
        let cellIdentifier = cellClass.defaultReusableIdentifier

        // Dequeue/init reusable cell
        var cell: AutoLayoutCell! = self.prototypeCells[cellIdentifier]

        if (cell == nil) {
            cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AutoLayoutCell)
            self.prototypeCells[cellIdentifier] = cell
        }

        self.dataSource.configureCell(cell, forIndexPath: indexPath)

        // Calculate height using auto layout
        return cell.heightForTableView(tableView)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        var view: UITableViewHeaderFooterView?

        if let viewClass = self.dataSource.headerClassForSection(section)
        {
            let viewIdentifier = viewClass.defaultReusableIdentifier

            // Dequeue/init reusable view
            if let dequeuedView = tableView.dequeueReusableHeaderFooterView(withIdentifier: viewIdentifier) {
                view = dequeuedView
                self.dataSource.configureHeader(dequeuedView, forSection: section)
            }
        }

        // Done
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        var height: CGFloat = 0.0

        if let viewClass = self.dataSource.headerClassForSection(section)
        {
            let viewIdentifier = viewClass.defaultReusableIdentifier

            // Dequeue/init reusable view
            var view: UITableViewHeaderFooterView! = self.prototypeHeaderFooterViews[viewIdentifier]

            if (view == nil) {
                view = tableView.dequeueReusableHeaderFooterView(withIdentifier: viewIdentifier)!
                self.prototypeHeaderFooterViews[viewIdentifier] = view
            }

            self.dataSource.configureHeader(view, forSection: section)

            // How do you use Auto Layout within UITableViewCell?
            // @link http://stackoverflow.com/a/18746930

            view.setNeedsUpdateConstraints()
            view.updateConstraintsIfNeeded()

            view.bounds = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: view.bounds.height)

            view.setNeedsLayout()
            view.layoutIfNeeded()

            let size = view.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            
            height = size.height
        }
        
        // Done
        return height
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        // Make cell separator looking the same on iOS 7+
        tableView.layoutMargins = UIEdgeInsets.zero

        if let autoLayoutCell = (cell as? AutoLayoutCell) {
            autoLayoutCell.parentTableView = tableView
        }

        // Notify delegate
        self.delegate.willDisplayCell(cell, forRowAtIndexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if let autoLayoutCell = (cell as? AutoLayoutCell) {
            autoLayoutCell.parentTableView = nil
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        // Notify delegate
        return self.delegate.willSelectRowAtIndexPath(indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Notify delegate
        self.delegate.didSelectRowAtIndexPath(indexPath)
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    {
        // Notify delegate
        return self.delegate.shouldHighlightRowAtIndexPath(indexPath)
    }

}

// ----------------------------------------------------------------------------
// MARK: - @protocol UITableViewDataSource
// ----------------------------------------------------------------------------

extension AutoLayoutTableViewHelper: UITableViewDataSource
{
// MARK: - Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellClass = self.dataSource.cellClassForIndexPath(indexPath)
        let cellIdentifier = cellClass.defaultReusableIdentifier

        // dequeue/init reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AutoLayoutCell
        self.dataSource.configureCell(cell, forIndexPath: indexPath)

        // Done
        return cell
    }

}

// ----------------------------------------------------------------------------
// MARK: - @protocol UIScrollViewDelegate
// ----------------------------------------------------------------------------

extension AutoLayoutTableViewHelper: UIScrollViewDelegate
{
// MARK: - Methods

    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.isTracking || scrollView.isDecelerating
        {
            let offset = scrollView.contentOffset.y
            let topOffset = CGPoint.zero.y
            let bottomOffset = (scrollView.contentSize.height - scrollView.bounds.size.height)

            if (offset < topOffset) {
                self.delegate.didReachTopScrollOffset()
            }
            else
            if (offset > bottomOffset) {
                self.delegate.didReachBottomScrollOffset()
            }

            if let minYTableFooterView = self.tableView.tableFooterView?.frame.minY, (minYTableFooterView - scrollView.bounds.maxY) > Inner.TableFooterBottomTreshold {
                self.delegate.tableFooterDidReachBottomTreshold()
            }

        }
        else {
            // "scroll view not tracking or decelerating"
        }

        self.scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.scrollViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

}

// ----------------------------------------------------------------------------

protocol AutoLayoutTableViewDataSource: class
{
// MARK: - Methods

    func numberOfSections() -> Int

    func numberOfRowsInSection(_ section: Int) -> Int

    func cellClassForIndexPath(_ indexPath: IndexPath) -> AutoLayoutCell.Type

    func configureCell(_ cell: AutoLayoutCell, forIndexPath indexPath: IndexPath)

    func headerClassForSection(_ section: Int) -> UITableViewHeaderFooterView.Type?

    func configureHeader(_ headerView: UITableViewHeaderFooterView, forSection section: Int)

}

// ----------------------------------------------------------------------------

protocol AutoLayoutTableViewDelegate: class
{
// MARK: - Methods

    func willSelectRowAtIndexPath(_ indexPath: IndexPath) -> IndexPath?

    func didSelectRowAtIndexPath(_ indexPath: IndexPath)

    func shouldHighlightRowAtIndexPath(_ indexPath: IndexPath) -> Bool

    func didRefresh()

    func didReachTopScrollOffset()

    func didReachBottomScrollOffset()

    func tableFooterDidReachBottomTreshold()

    func willDisplayCell(_ cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath)

}

// ----------------------------------------------------------------------------
