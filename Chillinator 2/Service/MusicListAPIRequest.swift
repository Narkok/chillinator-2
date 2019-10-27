//
//  MusicListAPIRequest.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 27/10/2019.
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
