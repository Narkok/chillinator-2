//
//  Array.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 27.06.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//

import Foundation


public extension Array {

    /// Безопасный доступ к элементу массива по индексу
    subscript(safe index: Int) -> Element? {
        get {
            guard index >= 0, index < count else { return nil }
            return self[index]
        }
        set {
            guard index >= 0, index < count, let element = newValue else { return }
            self[index] = element
        }
    }
}
