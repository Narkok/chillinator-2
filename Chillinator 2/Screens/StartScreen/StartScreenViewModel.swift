//
//  StartScreenViewModel.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 20/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import RxSwift
import RxCocoa

class StartScreenViewModel {
    
    /// Выходы в контроллер
    let output: Output

    struct Output {
        /// Конец загрузки
        let didFinishLoading: Driver<Void>
        /// Загруженный список песен
        let player: Driver<Player>
    }
    
    
    init(_ provider: MusicListProvider = MusicListService()) {
        
        /// Cписок песен
        let player = provider.list()
            .map { $0.element ?? [] }
            .map { Player(with: $0) }
            .share()
            .asDriver()
        
        /// Конец загрузки
        let didFinishLoading = player
            .asVoid()
        
        output = Output(didFinishLoading: didFinishLoading,
                        player: player)
    }
}
