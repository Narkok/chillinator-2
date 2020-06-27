//
//  UIView+Fade.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 18/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import UIKit


extension UIView {
    
    /// Анимированное изменение прозрачности
    /// - parameter alpha: Значение прозрачности
    /// - parameter duration: Длительность анимации
    func fadeTo(_ alpha: CGFloat, withDuration duration: TimeInterval = 0.4) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration) { [weak self] in
                self?.alpha = alpha
            }
        }
    }
    
    
    /// Анимированное изменение прозрачности до 0
    /// - parameter duration: Длительность анимации
    func fadeIn(withDuration duration: TimeInterval = 0.4) {
        fadeTo(1.0, withDuration: duration)
    }
    
    
    /// Анимированное изменение прозрачности до 1
    /// - parameter duration: Длительность анимации
    func fadeOut(withDuration duration: TimeInterval = 0.4) {
        fadeTo(0.0, withDuration: duration)
    }
    
    
    /// Поворот UIView
    /// - parameter angle: Угол поворота
    func rotate(by angle: CGFloat) {
        transform = CGAffineTransform(rotationAngle: angle)
    }
}


extension CALayer {
    /// Поворот CALayer
    /// - parameter angle: Угол поворота
    func rotate(by angle: CGFloat) {
        transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: angle))
    }
}
