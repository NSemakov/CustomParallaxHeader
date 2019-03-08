// ----------------------------------------------------------------------------
//
//  MenuCell.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

class MenuCell: AutoLayoutCell
{
// MARK: - Properties

    @IBOutlet private(set) weak var titleLabel: UILabel!

    @IBOutlet private(set) weak var menuItemImageView: UIImageView!

    @IBOutlet private(set) weak var labelTrailingConstraint: NSLayoutConstraint!

// MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()

        self.titleLabel.textColor = Inner.TextColor
    }

    func updateCell(_ viewModel: MenuItem)
    {
        self.titleLabel.text = viewModel.displayName
        self.menuItemImageView.image = viewModel.image

        // Show or hide custom accessory view

        if viewModel.accessoryType == .disclosureIndicator
        {
            self.accessoryType = .disclosureIndicator
            self.accessoryView = nil
            self.labelTrailingConstraint.constant = Inner.TrailingDisclosureConstant
        }
        else {
            self.accessoryType = .none
            self.accessoryView = nil
            self.labelTrailingConstraint.constant = Inner.TrailingNonDisclosureConstant
        }
    }

// MARK: - Constants

    private struct Inner
    {
        static let TextColor: UIColor = UIColor.gray
        static let TrailingDisclosureConstant: CGFloat = 0.0
        static let TrailingNonDisclosureConstant: CGFloat = 40.0
    }
}

// ----------------------------------------------------------------------------
