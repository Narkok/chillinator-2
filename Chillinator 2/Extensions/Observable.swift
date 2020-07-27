//
//  Observable.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 24.06.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//

import RxCocoa
import RxSwift
import Moya


public extension PublishRelay {
    
    func asDriver() -> Driver<Element> {
        return asDriver(onErrorDriveWith: Driver.empty())
    }
}


public extension Observable {

    func asDriver() -> Driver<Element> {
        return asDriver(onErrorDriveWith: Driver.empty())
    }
    
    func asVoid() -> Observable<Void> {
        return map { _ in () }
    }
    
    func filterNil<T>() -> Observable<T> where Element == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
    
    func delay(_ dueTime: RxTimeInterval) -> Observable<Element> {
        return delay(dueTime, scheduler: MainScheduler.asyncInstance)
    }
}


public extension Driver {
    
    func asVoid() -> Driver<Void> {
        return map { _ in () } as! Driver<Void>
    }
    
    func filterNil<T>() -> Driver<T> where Element == T? {
        return self.filter { $0 != nil }.map { $0! } as! Driver<T>
    }
}


public extension Single where Element == Response {
    func decode<T: Decodable>() -> Observable<Event<T>> {
        return Decoder.decode(request: self.asObservable().asSingle())
    }
    
    func decode<T: Decodable>(as: T.Type) -> Observable<Event<T>> {
        return Decoder.decode(request: self.asObservable().asSingle())
    }
}
