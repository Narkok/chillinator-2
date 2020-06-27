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


extension Reactive where Base: AVPlayerItem {
    
    /// Событие конца композиции
    public var didPlayToEnd: Observable<Void> {
        return NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime, object: base).asVoid()
    }
}
