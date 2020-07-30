//
//  Disk+Rx.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 27/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import RxSwift
import RxCocoa


extension Reactive where Base: Disk {
    
    /// Позиция головки проигрывателя
    var playHeadPosition: Binder<Float> {
        return Binder(self.base) { disk, time in
            disk.set(playHeadPosition: time)
        }
    }
    
    
    /// Обложка диска
    var coverImage: Binder<String> {
        return Binder(self.base) { disk, coverUrl in
            disk.set(cover: coverUrl)
        }
    }
    
    
    /// Обложка диска
    var scale: Binder<CGFloat> {
        return Binder(self.base) { disk, scale in
            disk.set(scale: scale)
        }
    }
    
    
    var isPlaying: Binder<Bool> {
        return Binder(self.base) { disk, isPlaying in
            disk.set(state: isPlaying ? .play : .stop )
        }
    }
}
