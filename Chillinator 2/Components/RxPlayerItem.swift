//
//  RxPlayerItem.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 20/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import RxCocoa
import RxSwift
import AVFoundation

/// Rx обертка над AVPlayerItem
class RxPlayerItem: AVPlayerItem {
    let disposeBag = DisposeBag()

    /// PlayerItem дошел до конца композиции
    var didPlayToEndTime: Observable<Void> {
        return NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime, object: self).asVoid()
    }
}


extension Observable {
    func asVoid() -> Observable<Void> { return map { _ in () } }
}
