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
    
    @IBOutlet private(set) weak var tableView: UITableView!
    
    @IBOutlet private(set) weak var headerContainerView: HeaderView!
    
    @IBOutlet private(set) weak var headerHeightConstraint: NSLayoutConstraint!
    
//    @IBOutlet private(set) weak var headerTopConstraint: NSLayoutConstraint!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init UI
        addChildViewController(self.headerController, toSubview: self.headerContainerView)
//        self.tableView.isScrollEnabled = false
        // Configure table view helper
        self.tableViewHelper = AutoLayoutTableViewHelper(tableView: self.tableView, dataSource: self, delegate: self)
        self.tableView.delegate = self.tableViewHelper
        self.tableView.dataSource = self.tableViewHelper
//        self.tableViewHelper.useHeaderRefreshControl = true
        self.tableViewHelper.scrollViewDelegate = self
        
        // Register table view cells
        self.tableView.registerCellClass(MenuCell.self)
        self.tableView.separatorColor = Inner.SeparatorColor
        
        self.tableView.tableFooterView = UIView()
//        self.tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0) //UIEdgeInsetsMake(self.maxHeight, 0, 0, 0)
//        self.tableView.contentInset = UIEdgeInsetsMake(self.maxHeight, 0, 0, 0)
        self.tableView.backgroundColor = Inner.BackgroundColor
        
        self.contentOffset = CGPoint(x: 0, y: self.maxHeight)
        self.contentOffsetPermanent = CGPoint(x: 0, y: self.maxHeight)
        
        self.headerHeightConstraint.constant = self.maxHeight
        
        let panGesture = UIPanGestureRecognizer(target: self, action: Actions.handlePan)
        self.headerContainerView.addGestureRecognizer(panGesture)
        self.tableView.isScrollEnabled = true
        addObserver(self.tableView, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
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
        let diff = old.y - new.y
        
//        let oldContentOffsetY = old.y
//        let newContentOffsetY = new.y
//        //        let oldContentOffsetY = self.contentOffsetPermanent.y
//
//        let diff = newContentOffsetY - oldContentOffsetY
//        self.contentOffset = scrollView.contentOffset
        print("! diff: \(diff)")
        //        self.contentOffset = CGPoint(x: self.contentOffset.x, y: newContentOffsetY)
        
        var proposedHeaderHeight = self.headerHeightConstraint.constant - diff // decrease when scroll from bottom to top and increase when scroll from top to bottom
        print("! proposedHeaderHeight: \(proposedHeaderHeight)")
        if diff > 0
        {
            // Scroll from bottom to top
            if proposedHeaderHeight < self.minHeight {
                //                self.contentOffset = CGPoint(x: self.contentOffset.x, y: newContentOffsetY)
                print("! 4 diff > 0; proposedHeaderHeight < self.minHeight")
            }
            else if proposedHeaderHeight > self.maxHeight {
                // Can't be here
                //                self.contentOffset = CGPoint(x: self.contentOffset.x, y: newContentOffsetY)
                print("! 4 diff > 0; proposedHeaderHeight > self.maxHeight")
            }
            else {
                self.headerHeightConstraint.constant = proposedHeaderHeight
                scroll(self.tableView, setContentOffset: CGPoint.zero)
                print("! 4 diff > 0; else")
            }
        }
        else {
            // Scroll from top to bottom
            if proposedHeaderHeight < self.minHeight {
                // Can't be here
                //                self.contentOffset = CGPoint(x: self.contentOffset.x, y: newContentOffsetY)
                print("! 5 diff < 0; proposedHeaderHeight < self.minHeight")
            }
            else if proposedHeaderHeight > self.maxHeight {
                // Pull header down
                // Must increase top constraint from header to superView
                //                self.contentOffset = CGPoint(x: self.contentOffset.x, y: newContentOffsetY)
                print("! 5 diff < 0; proposedHeaderHeight > self.minHeight")
            }
            else {
                if new.y > 0 {
                    //                    proposedHeaderHeight += diff
                    //                    self.contentOffset = CGPoint(x: self.contentOffset.x, y: newContentOffsetY)
                    print("! 5 diff < 0; scrollView.contentOffset.y > 0: \(new.y )")
                }
                else {
                    self.headerHeightConstraint.constant = proposedHeaderHeight
                    print("! 5 diff < 0; scrollView.contentOffset.y <= 0: \(new.y)")
                    scroll(self.tableView, setContentOffset: CGPoint.zero)
                }
            }
        }
    }
    
// MARK: - Actions
    
    @IBAction
    func handlePanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer)
    {
        switch gestureRecognizer.state
        {
            case .began:
                self.initialHeight = self.headerHeightConstraint.constant
            
            case .changed:
                let proposedHeaderHeight = self.initialHeight + gestureRecognizer.translation(in: self.view).y
                if proposedHeaderHeight >= self.maxHeight {
                    self.headerHeightConstraint.constant = self.maxHeight
                    // Pull header down
                    // Must increase top constraint from header to superView
                }
                else if proposedHeaderHeight <= self.minHeight {
                    self.headerHeightConstraint.constant = self.minHeight
                }
                else {
                    self.headerHeightConstraint.constant = proposedHeaderHeight
                }
            
            default:
                break
        }
        print("! handlePanGestureRecognizer")
    }
    
// MARK: - Private Methods
    
    private func updateInterface()
    {
        let cellTypes: [MenuItemType]
        
        cellTypes = [.manageProfile, .officesAndATMs, .currencyRates, .appSettings, .contactWithBank, .aboutApp, .exit, .aboutApp, .aboutApp, .aboutApp, .aboutApp]
//        cellTypes = [.manageProfile, .officesAndATMs]
        
        self.menuItems = cellTypes.map { return MenuItem(type: $0) }
        
        self.tableView.reloadData()
    }
    
    private func adjustContentOffset(for scrollView: UIScrollView)
    {
        let contentOffsetY = -scrollView.contentOffset.y
        
        // heightThreshold is Inner.ChangeHeightThreshold (0.5) of BaseProductRootController.DefaultHeight from bottom
        let heightThreshold = self.maxHeight - (Inner.ChangeHeightThreshold * (self.maxHeight - self.minHeight))
        if contentOffsetY < self.maxHeight && contentOffsetY > heightThreshold {
//            delayUserInteraction(on: scrollView)
            setHeaderState(.maximized, for: scrollView)
        }
        else
        if contentOffsetY < self.maxHeight && contentOffsetY <= heightThreshold
        {
//                delayUserInteraction(on: scrollView)
            setHeaderState(.minimized, for: scrollView)
        }
    }
    
    private func setHeaderState(_ state: HeaderState, for scrollView: UIScrollView)
    {
        switch state
        {
            case .minimized:
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: -self.minHeight), animated: true)
            
            case .maximized:
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: -self.maxHeight), animated: true)
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
        case minimized
        case maximized
    }
    
// MARK: - Constants
    
    private struct Actions {
        static let handlePan = #selector(ViewController.handlePanGestureRecognizer(_:))
    }
    
    private struct Inner
    {
        static let ProfileHeaderViewHeight: CGFloat = 60.0
        static let BackgroundColor: UIColor = UIColor(red: 68.0/255.0, green: 76.0/255.0, blue: 94.0/255.0, alpha: 1)
        static let TableContentInsets = UIEdgeInsetsMake(24.0, 0, 0, 0)
        static let ChangeHeightThreshold: CGFloat = 0.5 // 50 % from bottom
        static let SeparatorColor: UIColor = UIColor.gray
    }
    
    // MARK: - Variables
    
    private var tableViewHelper: AutoLayoutTableViewHelper!
    
    private var menuItems = [MenuItem]()
    
    private let headerController = EventDetailsHeaderController.controller()
    
    private var contentOffset: CGPoint = CGPoint(x: 0, y: 0)
    
    private var minHeight: CGFloat = 50
    
    private var maxHeight: CGFloat = 250
    
    private var initialHeight: CGFloat = 0
    
    private var contentOffsetPermanent: CGPoint = CGPoint(x: 0, y: 0)
    
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

    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
//        self.carouselController.setScrollEnabled(true)
//        scrollView.contentInset.top = -scrollView.contentOffset.y
//
        // After lifting finger with velocity == 0
        if !decelerate {
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