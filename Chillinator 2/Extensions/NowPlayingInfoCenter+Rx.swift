//
//  NowPlayingInfoCenter+Rx.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 05.07.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//

import RxSwift
import RxCocoa
import MediaPlayer
import Kingfisher


extension Reactive where Base: MPNowPlayingInfoCenter {
    
    /// Установка длительности композиции
    var duration: Binder<Double> {
        return Binder(self.base) { nowPlayingInfoCenter, duration in
            var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
            nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        }
    }
    
    /// Установка информации о композиции
    var music: Binder<Music> {
        return Binder(self.base) { nowPlayingInfoCenter, music in
            var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
            
            nowPlayingInfo[MPMediaItemPropertyArtist] = music.artist
            nowPlayingInfo[MPMediaItemPropertyTitle] = music.title
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MediaItemArtwork(with: UIImage(named: "logo"))
            nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
            
            guard let coverURL = music.getCoverURL else { return }
            KingfisherManager.shared.retrieveImage(with: coverURL) { [weak nowPlayingInfoCenter] result in
                let coverImage: UIImage? = {
                    if case let .success(data) = result { return data.image }
                    else { return UIImage(named: "logo") }
                }()
                nowPlayingInfoCenter?.nowPlayingInfo?[MPMediaItemPropertyArtwork] = MediaItemArtwork(with: coverImage)
            }
        }
    }
}


fileprivate class MediaItemArtwork: MPMediaItemArtwork {
    init(with image: UIImage?) {
        super.init(boundsSize: CGSize()) { [weak image] _ in return image ?? UIImage() }
    }
}
