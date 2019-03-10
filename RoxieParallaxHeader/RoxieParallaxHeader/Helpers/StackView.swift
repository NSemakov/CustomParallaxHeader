// ----------------------------------------------------------------------------
//
//  StackView.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2015, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit
import PureLayout

// ----------------------------------------------------------------------------

class StackView: UIView
{
// MARK: - Properties

    var verticalSpacing: CGFloat = 0.0 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

// MARK: - Methods

    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        subviewsDidUpdate()
    }

    override func bringSubview(toFront view: UIView) {
        super.bringSubview(toFront: view)
        subviewsDidUpdate()
    }

    override func sendSubview(toBack view: UIView) {
        super.sendSubview(toBack: view)
        subviewsDidUpdate()
    }

    override func insertSubview(_ view: UIView, at index: Int) {
        super.insertSubview(view, at: index)
        subviewsDidUpdate()
    }

    override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        super.insertSubview(view, aboveSubview: siblingSubview)
        subviewsDidUpdate()
    }

    override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        super.insertSubview(view, belowSubview: siblingSubview)
        subviewsDidUpdate()
    }

    override func exchangeSubview(at index1: Int, withSubviewAt index2: Int) {
        super.exchangeSubview(at: index1, withSubviewAt: index2)
        subviewsDidUpdate()
    }

    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        subviewsDidUpdate()
    }

    override func updateConstraints()
    {
        // Remove all constraints
        (self.constraints as NSArray).autoRemoveConstraints()

        // Add new constraints
        let subviews = self.subviews
        
        // Pin first superview to top
        subviews.first?.autoPinEdge(toSuperviewEdge: .top)
        
        // Distribute subviews along vertical axis
        if (subviews.count > 1)
        {
            (subviews as NSArray).autoDistributeViews(along: .vertical, alignedTo: .vertical,
                withFixedSpacing: self.verticalSpacing, insetSpacing: false, matchedSizes: false)
        }

        for subview in subviews
        {
            // Pin subview to superview left and right edge
            subview.autoPinEdge(toSuperviewEdge: .left)
            subview.autoPinEdge(toSuperviewEdge: .right)
        }
        
        // Pin last superview to bottom
        subviews.last?.autoPinEdge(toSuperviewEdge: .bottom)

        if subviews.isEmpty
        {
            NSLayoutConstraint.autoSetPriority(Inner.HeightConstraintPriority, forConstraints: {
                self.autoSetDimension(.height, toSize: CGFloat(0.0))
            })
        }

        super.updateConstraints()
    }

    func subviewsDidUpdate() {
        setNeedsUpdateConstraints()
    }

// MARK: - Constants

    private struct Inner {
        static let HeightConstraintPriority: UILayoutPriority = UILayoutPriority.defaultHigh
    }

}

// ----------------------------------------------------------------------------
