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
        let musicList: Driver<[Music]>
    }
    
    
    init(_ provider: MusicListProvider = MusicListService()) {
        /// Cписок песен
        let musicList = provider.list()
            .map { $0.element ?? [] }
            .share()
            .asDriver()
        
        /// Конец загрузки
        let didFinishLoading = musicList.asVoid()
        
        output = Output(didFinishLoading: didFinishLoading,
                        musicList: musicList)
    }
}
