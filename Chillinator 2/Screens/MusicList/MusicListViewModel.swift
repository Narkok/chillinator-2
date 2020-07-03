//
//  MusicListViewModel.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 22/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MusicListViewModel {
    
    let input = Input()
    let output: Output
    
    struct Input {
        let view = View()
        let parent = Parent()
        
        struct View {
            let willClose = PublishRelay<Void>()
            let change = PublishRelay<Player.Change>()
        }
        
        struct Parent {
            let isPlaying = PublishRelay<Bool>()
            let music = PublishRelay<Music>()
            let relativeTimer = PublishRelay<Float>()
        }
    }
    
    struct Output {
        let view: View
        let parent: Parent
        
        struct View {
            let music: Driver<Music>
            let isPlaying: Driver<Bool>
            let relativeTimer: Driver<Float>
            let list: Driver<[Music]>
        }
        
        struct Parent {
            let willClose: Driver<Void>
            let change: Observable<Player.Change>
        }
    }
    
    
    init(data: Player) {
        
        let outputView = Output.View(music: input.parent.music.share(replay: 1).asDriver(),
                                     isPlaying: input.parent.isPlaying.share(replay: 1).asDriver(),
                                     relativeTimer: input.parent.relativeTimer.share(replay: 1).asDriver(),
                                     list: Driver.just(data.list))
        
        let outputParent = Output.Parent(willClose: input.view.willClose.asDriver(),
                                         change: input.view.change.asObservable())
        
        output = Output(view: outputView,
                        parent: outputParent)
    }
}
