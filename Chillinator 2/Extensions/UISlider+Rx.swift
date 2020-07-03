//
//  UISlider+Rx.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 02.07.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UISlider {
    
    /// Установка значения
    var value: Binder<Float> {
        return Binder(self.base) { slider, value in
            slider.setValue(value, animated: !value.isZero)
        }
    }
}
