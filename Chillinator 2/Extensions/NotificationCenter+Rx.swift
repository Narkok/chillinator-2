//
//  NotificationCenter+Rx.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 04.07.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//

import RxSwift


extension Reactive where Base: NotificationCenter {

    /// Состояние приложения (Открыто или свернуто)
    public var isActive: Observable<Bool> {
        let a = NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification, object: UIApplication.shared).map { _ in true }
        let b = NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification, object: UIApplication.shared).map { _ in false }
        return Observable.merge(a, b).startWith(true).distinctUntilChanged()
    }
}
