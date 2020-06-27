//
//  UILabel+Rx.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 27.06.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {

    /// Анимированное изменение текста
    var smoothChangeText: Binder<String?> {
        return Binder(self.base) { label, text in
            let duration = 0.4
            label.fadeOut(withDuration: duration)
            Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { [weak label] _ in
                guard let label = label else { return }
                label.text = text
                label.fadeIn(withDuration: duration)
            })
        }
    }
}
