// ----------------------------------------------------------------------------
//
//  AutoLayoutCell.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2015, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

class AutoLayoutCell: UITableViewCell
{
// MARK: - Construction

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Init cell
        initAutoLayoutCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Init cell
        initAutoLayoutCell()
    }

// MARK: - Properties

    weak var parentTableView: UITableView?

    var hiddenCell: Bool = false

// MARK: - Methods

    func heightForTableView(_ tableView: UITableView) -> CGFloat
    {
        if self.hiddenCell
        {
            // Hide cell
            return 0
        }

        // How do you use Auto Layout within UITableViewCell?
        // @link http://stackoverflow.com/a/18746930

        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()

        self.bounds = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: self.bounds.height)

        setNeedsLayout()
        layoutIfNeeded()

        let size = self.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)

        var height = size.height

        // Add separator height if needed
        if (tableView.separatorStyle != .none)
        {
            height += 1
        }
        
        // Done
        return height
    }

// MARK: - Private Methods

    private func initAutoLayoutCell()
    {
        self.hiddenCell = self.isHidden

        for constraint in self.contentView.constraints
        {
            if (constraint.priority == UILayoutPriority.required) {
                constraint.priority = UILayoutPriority(constraint.priority.rawValue - 1.0)
            }
        }

        // Init view for highlighted and selected states
        let selectedView = UIView()
        selectedView.backgroundColor = Inner.SelectedBackgroundColor
        self.selectedBackgroundView = selectedView
    }

// MARK: - Constants

    private struct Inner {
        static let SelectedBackgroundColor: UIColor = UIColor.gray
    }

}

// ----------------------------------------------------------------------------
