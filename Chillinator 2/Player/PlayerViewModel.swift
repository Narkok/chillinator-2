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
        let play = PublishRelay<Void>()
        let change = PublishRelay<MusicList.ChangeType>()
    }
    
    struct Output {
        let music: Observable<Music>
    }

    init(data: [Music]) {
        
        /// Список песен
        let musicList = MusicList(from: data)
        
        /// 
        let musicNumChanged = input.change
            .scan(musicList) { list, changeType in
                var list = list
                list.changeMusic(by: changeType)
                return list
            }
            .startWith(musicList)
        
        let music = musicNumChanged.map { $0.getMusic() }
        
        output = Output(music: music)
    }
}
