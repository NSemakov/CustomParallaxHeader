// ----------------------------------------------------------------------------
//
//  RefreshControl.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2015, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

class RefreshControl: UIRefreshControl
{
// MARK: - Construction

    override init() {
        super.init()

        // register for notifications
        addObservers()
        self.tintColor = UIColor.white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // register for notifications
        addObservers()
        self.tintColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // register for notifications
        addObservers()
        self.tintColor = UIColor.white
    }

// MARK: - Methods

    override func beginRefreshing() {
        super.beginRefreshing()

        self.shouldRefreshing = true
    }

    override func endRefreshing() {
        super.endRefreshing()

        self.shouldRefreshing = false
    }

    func startRefreshingIfNeeded()
    {
        if self.shouldRefreshing && !self.isRefreshing
        {
            super.beginRefreshing()

            if let scrollView = self.superview as? UIScrollView
            {
                // scroll to activity indicator if it was visible before pausing
                if (scrollView.contentOffset == CGPoint.zero)
                {
                    scrollView.scrollRectToVisible(self.frame, animated: false)
                }
            }
        }
    }

    func pauseRefreshing()
    {
        super.endRefreshing()
    }

    @objc func mdc__applicationDidBecomeNotificationHandler(_ notification: Notification)
    {
        startRefreshingIfNeeded()
    }

    @objc func mdc__applicationWillResignActiveNotificationHandler(_ notification: Notification)
    {
        pauseRefreshing()
    }

    deinit
    {
        // unregister from notifications
        removeObservers()
    }

// MARK: - Private Methods

    private func addObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(RefreshControl.mdc__applicationDidBecomeNotificationHandler(_:)),
                name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RefreshControl.mdc__applicationWillResignActiveNotificationHandler(_:)),
                name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }

    private func removeObservers()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }

// MARK: - Variables

    private var shouldRefreshing = false
}

// ----------------------------------------------------------------------------
