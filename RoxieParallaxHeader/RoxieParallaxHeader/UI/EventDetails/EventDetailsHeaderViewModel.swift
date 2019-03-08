// ----------------------------------------------------------------------------
//
//  EventDetailsHeaderViewModel.swift
//
//  @author     Komarov Evgeniy <KomarovEV@ekassir.com>
//  @copyright  Copyright (c) 2018, Roxie Mobile Ltd. All rights reserved.
//  @link       http://www.roxiemobile.ru/
//
// ----------------------------------------------------------------------------

import Foundation
import MantarayCoreEntities

// ----------------------------------------------------------------------------

class EventDetailsHeaderViewModel
{
// MARK: - Construction

    init(event: PAEventModel)
    {
        self.imageName = event.imageName
        self.title = event.title
        self.amount = event.amount
    }

// MARK: - Properties

    private(set) var imageName: String?

    private(set) var title: String

    private(set) var amount: PAMoneyModel?
}

// ----------------------------------------------------------------------------
