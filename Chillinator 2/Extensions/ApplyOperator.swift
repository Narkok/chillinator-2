//
//  ApplyOperator.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 04.07.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//

import Foundation


infix operator ~: MultiplicationPrecedence
public func ~ <T>(value: T, apply: (T) -> Void) -> T {
    apply(value)
    return value
}
