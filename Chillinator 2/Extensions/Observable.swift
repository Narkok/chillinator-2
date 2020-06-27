//
//  Observable.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 24.06.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//

import RxCocoa
import RxSwift


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
}


public extension Driver {
    
    func asVoid() -> Driver<Void> {
        return map { _ in () } as! Driver<Void>
    }
    
    func filterNil<T>() -> Driver<T> where Element == T? {
        return self.filter { $0 != nil }.map { $0! } as! Driver<T>
    }
}
