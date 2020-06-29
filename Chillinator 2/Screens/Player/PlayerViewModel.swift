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
        let change = PublishRelay<Player.Change>()
        let showList = PublishRelay<Void>()
        let didPlayToEnd = PublishRelay<Void>()
    }
    
    struct Output {
        let music: Driver<Music>
        let openList: Driver<Player>
        let isPlaying: Driver<Bool>
    }

    
    init(with initialPlayer: Player) {
        
        /// Список песен
        let player = input.change
            .scan(initialPlayer) { list, changeType in
                var list = list
                list.changeMusic(by: changeType)
                return list
            }
            .startWith(initialPlayer)
            .share(replay: 1)
        
        /// Текущая композиция
        let music = player
            .map { $0.currentMusic() }
            .filterNil()
            .distinctUntilChanged()
            .share(replay: 1)
            .asDriver()
        
        /// Состояние текущей композиции
        let isPlaying = player
            .map { $0.isPlaying }
            .share(replay: 1)
            .asDriver()
        
        /// Открыть список композиций
        let openList = input.showList
            .withLatestFrom(player)
            .share(replay: 1)
            .asDriver()
        
        output = Output(music: music,
                        openList: openList,
                        isPlaying: isPlaying)
    }
}
