//
//  UIViewController+Rx.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 30.06.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


public extension Reactive where Base: UIViewController {
    
    var viewDidLoad: Observable<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad))
        return ControlEvent(events: source).asObservable().asVoid()
    }


    var viewWillAppear: Observable<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear))
        return ControlEvent(events: source).asObservable().asVoid()
    }


    var viewDidAppear: Observable<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear))
        return ControlEvent(events: source).asObservable().asVoid()
    }


    var viewWillDisappear: Observable<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear))
        return ControlEvent(events: source).asObservable().asVoid()
    }
    
    
    var viewDidDisappear: Observable<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear))
        return ControlEvent(events: source).asObservable().asVoid()
    }
}
