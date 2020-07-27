//
//  MusicListService.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 19/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa


/// Сервис для получения списка песен
struct MusicListService: MusicListProvider {
    
    static private let provider = MoyaProvider<MusicListAPIRequest>()
    
    /// Получить список песен
    func list() -> Observable<Event<[Music]>> {
        return MusicListService.provider.rx.request(.musicList).decode()
    }
}


protocol MusicListProvider {
    func list() -> Observable<Event<[Music]>>
}
