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
        let resultList = PublishRelay<Event<[Music]>>()
        MusicListService.provider.request(.musicList, completion: { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode([Music].self, from: response.data)
                    resultList.accept(.next(data))
                }
                catch { resultList.accept(.error(ServiceError(message: error.localizedDescription))) }
            case .failure: resultList.accept(.error(ServiceError(message: "Ошибка при запросе данных")))
            }
        })
        return resultList.asObservable()
    }
    
    
    struct ServiceError: Error {
        let message: String
    }
}


protocol MusicListProvider {
    func list() -> Observable<Event<[Music]>>
}
