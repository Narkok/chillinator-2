//
//  PlayerViewModel.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 18/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlayerViewModel {
    
    let input = Input()
    let output: Output
    
    struct Input {
        let change = PublishRelay<MusicList.ChangeType>()
    }
    
    struct Output {
        let music: Observable<Music>
        let musicList: Observable<MusicList>
        let isPlaying: Observable<Bool>
    }

    init(data: [Music]) {
        
        /// Список песен
        let initialMusicList = MusicList(from: data)
        let musicList = input.change
            .scan(initialMusicList) { list, changeType in
                var list = list
                list.changeMusic(by: changeType)
                return list
            }
            .startWith(initialMusicList)
            .share()
        
        /// Текущая композиция
        let music = musicList.map { $0.getMusic() }.distinctUntilChanged()
        
        /// Состояние текущей композиции
        let isPlaying = musicList.map { $0.isPlaying }.distinctUntilChanged()
        
        output = Output(music: music,
                        musicList: musicList,
                        isPlaying: isPlaying)
    }
}
