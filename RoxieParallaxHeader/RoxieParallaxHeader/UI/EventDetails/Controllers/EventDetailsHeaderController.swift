// ----------------------------------------------------------------------------
//
//  EventDetailsHeaderController.swift
//
//  @author     Komarov Evgeniy <KomarovEV@ekassir.com>
//  @copyright  Copyright (c) 2018, Roxie Mobile Ltd. All rights reserved.
//  @link       http://www.roxiemobile.ru/
//
// ----------------------------------------------------------------------------

import UIKit
import ModernDesignExtensions

// ----------------------------------------------------------------------------

class EventDetailsHeaderController: BaseViewController
{
// MARK: - Construction

    class func controller() -> Self
    {
        let controller = mdc_controller(storyboardName: nil)!
        return controller
    }

// MARK: - Properties

    @IBOutlet private(set) weak var titleLabel: UILabel!

    @IBOutlet private(set) weak var amountLabel: UILabel!

//    @IBOutlet private(set) weak var backgroundTopConstraint: NSLayoutConstraint!

    @IBOutlet private(set) var controlButtons: [UIButton]!

// MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.textColor = Inner.TitleTextColor
        self.amountLabel.textColor = Inner.AmountTextColor
    }


    func setControlButtons(_ enabled: Bool)
    {
        self.controlButtons.forEach {
            $0.isUserInteractionEnabled = enabled
        }
    }

    // Adjust background view height appropriately to enclosing scrollView content offset
//    func updateBackgroundFrame(_ offset: CGPoint)
//    {
//        if self.backgroundTopConstraint.constant < Inner.BackgroundHeightDefault {
//            self.backgroundTopConstraint.constant = (Inner.BackgroundHeightDefault + offset.y)
//        }
//        else {
//            self.backgroundTopConstraint.constant = (Inner.BackgroundHeightDefault - offset.y)
//        }
//    }

// MARK: - Actions

    @IBAction
    func touchRecieptButton(_ sender: Any) {
    }

    @IBAction
    func touchRepeatButton(_ sender: Any) {
    }

// MARK: - Private Methods


// MARK: - Inner Types

    private struct Inner
    {
        static let ImageSize = CGSize(width: 72.0 * UIScreen.main.scale, height: 72.0 * UIScreen.main.scale)
        static let ImageSizePathComponent = "\(Int(Inner.ImageSize.width))x\(Int(Inner.ImageSize.height))"
        static let TitleTextColor: UIColor = UIColor.white
        static let AmountTextColor: UIColor = UIColor.white
        static let ReceiptTextColor: UIColor = UIColor.white
        static let RepeatTextColor: UIColor = UIColor.white

        static let BackgroundHeightDefault: CGFloat = 320
    }

// MARK: - Constants

    // ...

// MARK: - Variables

    // ...
}

// ----------------------------------------------------------------------------
