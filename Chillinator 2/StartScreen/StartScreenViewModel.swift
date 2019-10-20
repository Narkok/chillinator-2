//
//  StartScreenViewModel.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 20/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import RxSwift

class StartScreenViewModel {
    
    /// Сервис для получения списка песен
    private static let musicListService = MusicListService()
    
    /// Выходы в контроллер
    let output: Output

    struct Output {
        /// Конец загрузки
        let didFinishLoading: Observable<Void>
        /// Загруженный список песен
        let musicList: Observable<[Music]>
    }
    
    
    init() {
        /// Cписок песен
        let musicList = StartScreenViewModel.musicListService.getList()
            .map { $0.element ?? [] }
            .share()
        
        /// Конец загрузки
        let didFinishLoading = musicList.map { _ in () }
        
        output = Output(didFinishLoading: didFinishLoading,
                        musicList: musicList)
    }
}
