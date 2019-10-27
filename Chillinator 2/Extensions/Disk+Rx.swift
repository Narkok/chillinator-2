//
//  Disk+Rx.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 27/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: Disk {
    /// Установка позиции головки проигрывателя
    var playHeadPosition: Binder<Double> {
        return Binder(self.base) {
            disk, time in disk.setPlayHeadPosition(relativeTime: time)
        }
    }
}
