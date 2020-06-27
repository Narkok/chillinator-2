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
        let showList = PublishRelay<Void>()
        let didPlayToEnd = PublishRelay<Void>()
    }
    
    struct Output {
        let music: Driver<Music>
        let musicList: Driver<MusicList>
        let isPlaying: Driver<Bool>
    }

    
    init(musicList initialMusicList: MusicList) {
        
        /// Список песен
        let musicList = input.change
            .scan(initialMusicList) { list, changeType in
                var list = list
                list.changeMusic(by: changeType)
                return list
            }
            .startWith(initialMusicList)
            .share(replay: 1)
        
        /// Текущая композиция
        let music = musicList
            .map { $0.currentMusic() }
            .filterNil()
            .distinctUntilChanged()
            .share(replay: 1)
            .asDriver()
        
        /// Состояние текущей композиции
        let isPlaying = musicList
            .map { $0.isPlaying }
            .share(replay: 1)
            .asDriver()
        
        let openList = input.showList
            .withLatestFrom(musicList)
            .share(replay: 1)
            .asDriver()
        
        output = Output(music: music,
                        musicList: openList,
                        isPlaying: isPlaying)
    }
}
