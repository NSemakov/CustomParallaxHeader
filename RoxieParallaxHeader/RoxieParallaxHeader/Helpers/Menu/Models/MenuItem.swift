// ----------------------------------------------------------------------------
//
//  MenuItem.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2018, Roxie Mobile Ltd. All rights reserved.
//  @link       http://www.roxiemobile.ru/
//
// ----------------------------------------------------------------------------

import UIKit

class MenuItem
{
// MARK: - Construction

    init(type: MenuItemType) {

        let accessory: UITableViewCellAccessoryType
        var image: UIImage?
        let displayName: String

        switch type
        {
            case .manageProfile:
                accessory = .disclosureIndicator
//                image = R.image.ic_menu_profile()
                displayName = "manageProfile"

            case .officesAndATMs:
                accessory = .disclosureIndicator
//                image = R.image.ic_menu_geo()
                displayName = "officesAndATMs"

            case .currencyRates:
                accessory = .disclosureIndicator
//                image = R.image.ic_menu_exchange()
                displayName = "currencyRates"

            case .appSettings:
                accessory = .disclosureIndicator
//                image = R.image.ic_menu_settings()
                displayName = "appSettings"

            case .contactWithBank:
                accessory = .disclosureIndicator
//                image = R.image.ic_menu_feedback()
                displayName = "contactWithBank"

            case .aboutApp:
                accessory = .disclosureIndicator
//                image = R.image.ic_menu_info()
                displayName = "aboutApp"

            case .exit:
                accessory = .none
//                image = R.image.ic_menu_exit()
                displayName = "exit"
        }

        self.type = type
        self.image = image
        self.displayName = displayName
        self.accessoryType = accessory
    }

// MARK: - Properties

    let image: UIImage?

    let displayName: String

    let type: MenuItemType

    let accessoryType: UITableViewCellAccessoryType

// MARK: - Methods

    // ...

// MARK: - Actions

    // ...

// MARK: - Private Methods

    // ...

// MARK: - Inner Types

    // ...

// MARK: - Constants

    // ...

// MARK: - Variables

    // ...
}

// ----------------------------------------------------------------------------
