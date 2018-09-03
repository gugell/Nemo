//
//  DataFaker.swift
//  Legato
//
//  Setups:
//
//  1.- Login
//    => SessionFaker(false)
//    => SessionFaker(false), ValidSessionFaker(false)
//  2.- Error
//    => SessionFaker(true), ValidSessionFaker(true), UserFaker(false)
//  3.- Main
//    => SessionFaker(true), ValidSessionFaker(true), UserFaker(true)
//
//  Created by Luis Burgos on 7/23/18.
//  Copyright © 2018 Yellowme. All rights reserved.
//

import Foundation

/// 1st validation
class SessionFaker {
    func hasSessionStarted() -> Bool {
        return true
    }
}

/// 2nd validation
class ValidSessionFaker {
    func hasValidSession() -> Bool {
        return true
    }
}

/// 3rd validation
class UserFaker {
    func userHasSomeValidProperty() -> Bool {
        return true
    }
}
