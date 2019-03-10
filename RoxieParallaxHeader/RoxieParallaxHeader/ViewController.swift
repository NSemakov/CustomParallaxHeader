// ----------------------------------------------------------------------------
//
//  MenuController.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

import DispatchFramework
import UIKit

// ----------------------------------------------------------------------------

class ViewController: UIViewController
{
// MARK: - Construction
    
    
// MARK: - Properties
    
    @IBOutlet private(set) weak var scrollView: UIScrollView!
    
    @IBOutlet private(set) weak var tableView: UITableView!
    
    @IBOutlet private(set) weak var headerContainerView: HeaderView!
    
    @IBOutlet private(set) weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private(set) weak var dummyViewHeightConstraint: NSLayoutConstraint!
    
    //    @IBOutlet private(set) weak var headerTopConstraint: NSLayoutConstraint!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init UI
        addChildViewController(self.headerController, toSubview: self.headerContainerView)

        // Configure table view helper
        self.tableViewHelper = AutoLayoutTableViewHelper(tableView: self.tableView, dataSource: self, delegate: self)
        self.tableView.delegate = self.tableViewHelper
        self.tableView.dataSource = self.tableViewHelper
        self.tableViewHelper.scrollViewDelegate = self
        
        // Register table view cells
        self.tableView.registerCellClass(MenuCell.self)
        self.tableView.separatorColor = Inner.SeparatorColor
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = Inner.BackgroundColor
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.maxHeight, 0, 0, 0)
        
        self.headerHeightConstraint.constant = self.maxHeight
        
        // Add observers
        self.tableView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        
        // Set height such that we can move header up and down. And if we move up, we shouldn't be able to move header such that it heights will be less than self.minHeight
        self.dummyViewHeightConstraint.constant = self.scrollView.bounds.height - self.minHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update UI
        updateInterface()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset",
        let change = change else
        {
            print("Another keypath")
            return
        }
        
        let new = change[.newKey] as! CGPoint
        let old = change[.oldKey] as! CGPoint
        let diff = new.y - old.y
        
        if (diff == 0.0 || !self.isObserving) {
            return
        }

        print("! diff: \(diff)")
        let visibleHeaderPartHeight = self.scrollView.bounds.intersection(self.headerContainerView.bounds).height
        print("! visibleHeaderPartHeight: \(visibleHeaderPartHeight)")
        if let object = object as? AnyObject, object === self.tableView
        {
            let tableViewOffsetForCompareAsZeroReference = self.tableView.contentOffset.y + self.tableView.contentInset.top
            print("! self.tableView.contentOffset.y: \(self.tableView.contentOffset.y)")
            let proposedHeaderContentOffsetY = self.scrollView.contentOffset.y + diff // decrease when scroll from bottom to top and increase when scroll from top to bottom
            var proposedHeaderContentOffset = CGPoint(x: self.scrollView.contentOffset.x, y: proposedHeaderContentOffsetY)
//            print("! self.headerHeightConstraint.constant: \(self.headerHeightConstraint.constant), diff: \(diff), proposedHeaderHeight: \(proposedHeaderHeight)")
            if diff > 0
            {
                // Scroll from bottom to top
                if visibleHeaderPartHeight < self.minHeight {
//                    self.headerHeightConstraint.constant = self.minHeight
                    // Pull header up
//                    scroll(self.scrollView, setContentOffset: newScrollViewContentOffset)
//                    let minContentOffset = CGPoint(x: self.scrollView.contentOffset.x, y: self.headerContainerView.height - self.minHeight)
//                    scroll(self.scrollView, setContentOffset: minContentOffset)
                    print("! 4.1 diff > 0; proposedHeaderHeight < self.minHeight")
                }
                else if visibleHeaderPartHeight > self.maxHeight {
                    // Can't be here
//                    self.headerHeightConstraint.constant = self.maxHeight
                    print("! 4.2 diff > 0; proposedHeaderHeight > self.maxHeight")
                }
                else {
//                    self.headerHeightConstraint.constant = proposedHeaderHeight
                    // Pull header up
                    let newVisibleHeaderPartHeight = visibleHeaderPartHeight - diff
                    if newVisibleHeaderPartHeight < self.minHeight {
                        // Need proper handling for cases, where header can change it's height. self.maxHeight  in self.maxHeight - self.minHeight should be changed.
                        proposedHeaderContentOffset = CGPoint(x: self.scrollView.contentOffset.x, y: self.maxHeight - self.minHeight)
                    }
                    
                    scroll(self.scrollView, setContentOffset: proposedHeaderContentOffset)
                    
                    print("! 4.3 diff > 0; else")
                }
            }
            else {
                // Scroll from top to bottom
                
                if visibleHeaderPartHeight < self.minHeight {
                    // Can't be here
//                    self.headerHeightConstraint.constant = self.minHeight
                    //                self.contentOffset = CGPoint(x: self.contentOffset.x, y: newContentOffsetY)
                    print("! 5.1 Scroll from top to bottom; proposedHeaderHeight < self.minHeight")
                }
                else if visibleHeaderPartHeight >= self.maxHeight
                {
                    // visibleHeaderPartHeight rarely can be > maxHeight. 
                    // Must increase top constraint from header to superView
//                    self.headerHeightConstraint.constant = self.maxHeight
                    
                    if new.y > -self.maxHeight {
                        print("! 5.2 Scroll from top to bottom; scrollView.contentOffset.y > 0: \(-new.y), visibleHeaderPartHeight: \(visibleHeaderPartHeight)")
                    }
                    else {
                        print("! 5.3 Scroll from top to bottom; scrollView.contentOffset.y <= 0: \(-new.y), visibleHeaderPartHeight: \(visibleHeaderPartHeight)")
//                        scroll(self.tableView, setContentOffset: old)
                        
                        // Pull header down
                        scroll(self.scrollView, setContentOffset: proposedHeaderContentOffset)
                    }
                }
                else {
                    if -new.y < visibleHeaderPartHeight {
                        print("! 5.4 Scroll from top to bottom; scrollView.contentOffset.y > 0: \(new.y), visibleHeaderPartHeight: \(visibleHeaderPartHeight)")
                    }
                    else {
//                        self.headerHeightConstraint.constant = proposedHeaderHeight
                        print("! 5.5 Scroll from top to bottom; scrollView.contentOffset.y <= 0: \(new.y), visibleHeaderPartHeight: \(visibleHeaderPartHeight)")
//                        scroll(self.tableView, setContentOffset: old)
                        // Pull header down
                        scroll(self.scrollView, setContentOffset: proposedHeaderContentOffset)
                    }
                }
            }
        }
        else
        if let object = object as? AnyObject, object === self.scrollView
        {
            let b = 2
            print(b)
            let a = 3
        }
        
        
    }
    
// MARK: - Actions
    
    // ...
    
// MARK: - Private Methods
    
    private func nearestState() -> HeaderState {
        // Watch for half-height difference between max and min state.
        let constantToCompare = (heightForState(.maximized) - heightForState(.minimized)) / 2.0
        let currentConstant = heightForState(.maximized) - self.headerHeightConstraint.constant
        
        return (currentConstant > constantToCompare) ? .minimized : .maximized
    }
    
    private func heightForState(_ state: HeaderState) -> CGFloat
    {
        switch state
        {
            case .hidden:    return 0.0
            case .minimized: return self.minHeight
            case .maximized: return self.maxHeight
        }
    }
    
    private func updateInterface()
    {
        let cellTypes: [MenuItemType]
        
        cellTypes = [.manageProfile, .officesAndATMs, .currencyRates, .appSettings, .contactWithBank, .aboutApp, .exit, .manageProfile, .officesAndATMs, .currencyRates, .appSettings, .contactWithBank, .aboutApp, .exit, .manageProfile, .officesAndATMs, .currencyRates, .appSettings, .contactWithBank, .aboutApp, .exit]
//        cellTypes = [.manageProfile, .officesAndATMs]
        
        self.menuItems = cellTypes.map { return MenuItem(type: $0) }
        
        self.tableView.reloadData()
    }
    
//    private func adjustContentOffset(for scrollView: UIScrollView)
//    {
//        let contentOffsetY = -scrollView.contentOffset.y
//
//        // heightThreshold is Inner.ChangeHeightThreshold (0.5) of BaseProductRootController.DefaultHeight from bottom
//        let heightThreshold = self.maxHeight - (Inner.ChangeHeightThreshold * (self.maxHeight - self.minHeight))
//        if contentOffsetY < self.maxHeight && contentOffsetY > heightThreshold {
////            delayUserInteraction(on: scrollView)
//            setHeaderState(.maximized, for: scrollView)
//        }
//        else
//        if contentOffsetY < self.maxHeight && contentOffsetY <= heightThreshold
//        {
////                delayUserInteraction(on: scrollView)
//            setHeaderState(.minimized, for: scrollView)
//        }
//    }
    
    private func setHeaderState(_ state: HeaderState, animated: Bool)
    {
        let height = heightForState(state)
        if (height != self.headerHeightConstraint.constant)
        {
            if (state == .maximized)
            {
//                self.delegate?.bottomSlideViewWillMaximize(self)
            }
            else {
//                self.delegate?.bottomSlideViewWillMinimize(self)
            }
            
            weak var weakSelf = self
            let changes: () -> Void = {
                weakSelf?.headerHeightConstraint.constant = height
                weakSelf?.view.layoutIfNeeded()
            }
            
            if animated
            {
                UIView.animate(withDuration: Inner.PanAnimationDuration, animations: changes)
            }
            else {
                changes()
            }
        }
    }
    
    private func scroll(_ scrollView: UIScrollView, setContentOffset offset: CGPoint)
    {
        self.isObserving = false
        scrollView.contentOffset = offset
        self.isObserving = true
    }
    
// MARK: - Inner Types
    
    private enum HeaderState {
        case hidden
        case minimized
        case maximized
    }
    
// MARK: - Constants
    
    private struct Inner
    {
        static let ProfileHeaderViewHeight: CGFloat = 60.0
        static let BackgroundColor: UIColor = UIColor(red: 68.0/255.0, green: 76.0/255.0, blue: 94.0/255.0, alpha: 1)
        static let TableContentInsets = UIEdgeInsetsMake(24.0, 0, 0, 0)
        static let ChangeHeightThreshold: CGFloat = 0.5 // 50 % from bottom
        static let SeparatorColor: UIColor = UIColor.gray
        
        static let PanAnimationDuration: TimeInterval = 0.30
        static let PanVelocityThreshold: CGFloat = 300
    }
    
    // MARK: - Variables
    
    private var tableViewHelper: AutoLayoutTableViewHelper!
    
    private var menuItems = [MenuItem]()
    
    private let headerController = EventDetailsHeaderController.controller()
    
    private var minHeight: CGFloat = 50
    
    private var maxHeight: CGFloat = 190
    
    private var initialHeight: CGFloat = 0
    
    private var isObserving = true
}

extension ViewController: UIScrollViewDelegate
{
// MARK: - Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
//        let translation = scrollView.panGestureRecognizer.translation(in: self.view)
//        print("! translation: \(translation.y)")
    }
    
    // Turn off horizontal scroll in collection view, if vertical is started. And vice versa.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        // Called after programmatic changes and when user tap scroll to stop it
//        adjustContentOffset(for: scrollView)
//        self.carouselController.scrollViewDidEndScroll()
//        self.contentController?.scrollViewDidEndScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Called after touching
        // After lifting finger with abs(velocity) > 0
//        adjustContentOffset(for: scrollView)
//        setHeaderState(nearestState(), animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
//        self.carouselController.setScrollEnabled(true)
//        scrollView.contentInset.top = -scrollView.contentOffset.y
//
        // After lifting finger with velocity == 0
        if !decelerate {
//            setHeaderState(nearestState(), animated: true)
//            adjustContentOffset(for: scrollView)

            // To enable tap on cell when user scrolls without deceleration
//            self.contentController?.scrollViewDidEndScroll()
        }
    }
}
// ----------------------------------------------------------------------------
// MARK: - @protocol AutoLayoutTableViewDataSource
// ----------------------------------------------------------------------------

extension ViewController: AutoLayoutTableViewDataSource
{
    // MARK: - Methods
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.menuItems.count
    }
    
    func cellClassForIndexPath(_ indexPath: IndexPath) -> AutoLayoutCell.Type {
        return MenuCell.self
    }
    
    func configureCell(_ cell: AutoLayoutCell, forIndexPath indexPath: IndexPath)
    {
        if let cell = (cell as? MenuCell) {
            let menuItem = self.menuItems[indexPath.row]
            cell.updateCell(menuItem)
        }
    }
    
    func headerClassForSection(_ section: Int) -> UITableViewHeaderFooterView.Type? {
        return nil
    }
    
    func configureHeader(_ headerView: UITableViewHeaderFooterView, forSection section: Int) {
        // Do nothing ..
    }
    
}

// ----------------------------------------------------------------------------
// MARK: - @protocol AutoLayoutTableViewDelegate
// ----------------------------------------------------------------------------

extension ViewController: AutoLayoutTableViewDelegate
{
// MARK: - Methods
    
    func willSelectRowAtIndexPath(_ indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    func didSelectRowAtIndexPath(_ indexPath: IndexPath)
    {
//        let menuItem = self.menuItems[indexPath.row]
    }
    
    func shouldHighlightRowAtIndexPath(_ indexPath: IndexPath) -> Bool {
        return true
    }
    
    func didRefresh() {
//        Dispatch.after(2.0) {
//            self.tableViewHelper.endRefreshing()
//        }
    }
    
    func didReachTopScrollOffset() {
        // Do nothing ..
    }
    
    func didReachBottomScrollOffset() {
        // Do nothing ..
    }
    
    func tableFooterDidReachBottomTreshold() {
        // Do nothing ..
    }
    
    func willDisplayCell(_ cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        // Do nothing ..
    }
}

// ----------------------------------------------------------------------------
