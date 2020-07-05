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
    
    /// Установка информации о композиции
    var info: Binder<(duration: Double, music: Music)> {
        return Binder(self.base) { nowPlayingInfoCenter, info in
            var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
            
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = info.duration
            nowPlayingInfo[MPMediaItemPropertyArtist] = info.music.artist
            nowPlayingInfo[MPMediaItemPropertyTitle] = info.music.title
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MediaItemArtwork(with: UIImage(named: "logo"))
            
            nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
            
            guard let coverURL = info.music.getCoverURL else { return }
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
