//
//  UIView+Fade.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 18/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import UIKit

extension UIView {
    func fadeTo(_ alpha: CGFloat, withDuration duration: TimeInterval = 0.3) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration) { [unowned self] in
                self.alpha = alpha
            }
        }
    }
    
    func fadeIn(withDuration duration: TimeInterval = 0.3) {
        fadeTo(1.0, withDuration: duration)
    }
    
    func fadeOut(withDuration duration: TimeInterval = 0.3) {
        fadeTo(0.0, withDuration: duration)
    }
}
