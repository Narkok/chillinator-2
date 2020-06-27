//
//  AVPlayer+Rx.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 27/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa


extension Reactive where Base: AVPlayer {
    
    /// Отношение прошедшего времени композиции ко всей длине, от 0 до 1
    public var relativeTimer: Observable<Double> {
        return Observable.create { observer in
            let timer = self.base.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: nil) { time in
                if let currentItem = self.base.currentItem { observer.onNext(Double(CMTimeGetSeconds(time) / CMTimeGetSeconds(currentItem.asset.duration))) }
                else { observer.onNext(0) }
            }
            return Disposables.create { self.base.removeTimeObserver(timer) }
        }
    }
    
    
    /// Не знаю как эту штуку назвать ¯\_(ツ)_/¯
    public var playerItem: Binder<AVPlayerItem> {
        return Binder(self.base) { player, playerItem in
            player.replaceCurrentItem(with: playerItem)
        }
    }
    
    
    /// Состояние плеера
    public var play: Binder<Bool> {
        return Binder(self.base) { player, isPlaying in
            isPlaying ? player.play() : player.pause()
        }
    }
}
