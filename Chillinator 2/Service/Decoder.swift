//
//  Decoder.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 27.07.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct Decoder {
    public static func decode<T: Decodable>(request: PrimitiveSequence<SingleTrait, Response>) -> Observable<Event<T>> {
        return request.asObservable().map { try decode(data: $0.data) as T }
            .materialize()
            .filter { !$0.event.isCompleted }
            .catchError { _ in .just(.error(ServiceError.decodingError)) }
    }
    
    private static func decode<T: Decodable>(type: T.Type = T.self, data: Data) throws -> T {
        do { return try JSONDecoder().decode(T.self, from: data) }
        catch { throw error }
    }
}
