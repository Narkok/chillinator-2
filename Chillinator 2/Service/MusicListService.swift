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


/// Запрос для получения списка песен
enum MusicListAPIRequest: TargetType {
    case getList
    var baseURL: URL { return URL(string: "http://nrkk.ru")! }
    var path: String { return "chillinator/musicList.json" }
    var method: Moya.Method { return .get }
    var task: Task { return .requestPlain }
    var headers: [String : String]? { return ["Content-Type": "application/json"] }
    var sampleData: Data { return "{}".data(using: .utf8)! }
}


/// Структура песни
struct Music: Codable {
    let title: String
    let artist: String
    let coverURL: String
    let musicURL: String
}


/// Сервис для получения списка песен
class MusicListService {
    
    static private let provider = MoyaProvider<MusicListAPIRequest>()
    private let musicList = PublishRelay<Event<[Music]>>()
    
    /// Получить список песен
    func getList() -> Observable<Event<[Music]>> {
        MusicListService.provider.request(.getList, completion: { [unowned self] result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode([Music].self, from: response.data)
                    self.musicList.accept(.next(data))
                }
                catch { self.musicList.accept(.error(AMDMError(message: "Ошибка при парсинге данных: \(error)"))) }
            case .failure: self.musicList.accept(.error(AMDMError(message: "Ошибка при запросе данных")))
            }
        })
        return musicList.asObservable()
    }
    
    
    struct AMDMError: Error {
        let message: String
    }
}