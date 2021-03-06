//
//  Disk.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 18/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import UIKit
import Kingfisher

@IBDesignable class Disk: UIView {
    
    @IBInspectable private var size: CGFloat = 700
    @IBInspectable private var backgroundImage: UIImage = UIImage()
    @IBInspectable private var shineImage: UIImage = UIImage()
    @IBInspectable private var pipkaImage: UIImage = UIImage()
    @IBInspectable private var playheadImage: UIImage = UIImage()
    
    private let discImageLayer     = CALayer()
    private let pipkaImageView     = CALayer()
    private let shine1ImageLayer   = CALayer()
    private let shine2ImageLayer   = CALayer()
    
    private let coverImageView    = UIImageView()
    private let playHeadImageView = UIImageView()

    private var shine1RotAngle = CGFloat.random(in: -CGFloat.pi...CGFloat.pi)
    private var shine2RotAngle = CGFloat.random(in: -CGFloat.pi...CGFloat.pi)
    private var discRotAngle   = CGFloat.random(in: -CGFloat.pi...CGFloat.pi)
    private var coverRotAngle  = CGFloat.zero
    
    private var isLoaded = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if isLoaded { return }
        isLoaded = true
        
        self.layer.addSublayer(discImageLayer)
        self.layer.addSublayer(shine1ImageLayer)
        self.layer.addSublayer(shine2ImageLayer)
        self.addSubview(coverImageView)
        self.layer.addSublayer(pipkaImageView)
        self.addSubview(playHeadImageView)
        
        /// Установка фона диска
        discImageLayer.contents  = backgroundImage.cgImage
        discImageLayer.bounds    = CGRect(x: 0, y: 0, width: size, height: size)
        discImageLayer.rotate(by: discRotAngle)
        discImageLayer.shadowColor   = UIColor.black.cgColor
        discImageLayer.shadowRadius  = 15
        discImageLayer.shadowOpacity = 0.7
        
        /// Установка бликов
        shine1ImageLayer.contents  = shineImage.cgImage
        shine1ImageLayer.bounds    = CGRect(x: 0, y: 0, width: size, height: size)
        shine1ImageLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: shine1RotAngle))
        
        shine2ImageLayer.contents  = shineImage.cgImage
        shine2ImageLayer.bounds    = CGRect(x: 0, y: 0, width: size, height: size)
        shine2ImageLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: shine2RotAngle))
        
        /// Установка обложки песни
        let coverImageSize           = Int(Double(size) * 0.4)
        coverImageView.clipsToBounds = true
        coverImageView.bounds        = CGRect(x: 0, y: 0, width: coverImageSize, height: coverImageSize)
        coverImageView.layer.cornerRadius = CGFloat(coverImageSize)/2
        
        /// Установка центральной оси
        pipkaImageView.allowsEdgeAntialiasing = true
        pipkaImageView.bounds = CGRect(x: 0, y: 0, width: size / 35, height: size / 35)
        pipkaImageView.masksToBounds = true
        pipkaImageView.cornerRadius = size / 70
        pipkaImageView.contents  = pipkaImage.cgImage
        
        /// Установка головки проигрывателя
        let ratioSize: CGFloat = 21.6
        let phivX: CGFloat = size / 6.8
        let phivY: CGFloat = -size / 1.53
        let phivWidth = size * 6 / ratioSize
        let phivHeight = size * 19 / ratioSize
        playHeadImageView.image = playheadImage
        playHeadImageView.layer.anchorPoint = CGPoint(x: 0.87, y: 0.035)
        playHeadImageView.frame = CGRect(x: phivX, y: phivY, width: phivWidth, height: phivHeight)
    }
    
    
    /// Размер диска
    func set(size: CGFloat) {
        self.size = size
    }
    
    
    /// Анимированная установка новой обложки
    func set(cover url: String) {
        let duration = 0.4
        /// Затемнить обложку
        coverImageView.fadeOut(withDuration: duration)
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            guard let url = URL(string: url) else { return }
            
            /// Загрузить новую обложку
            self?.coverImageView.image = nil
            self?.coverImageView.kf.setImage(with: url) { [weak self] _ in
                /// Показать новую обложку
                self?.coverImageView.fadeIn(withDuration: duration)
            }
        }
    }
    
    
    /// Установка позиции головки проигрывателя
    func set(playHeadPosition relativeTime: Float) {
        let angle = -CGFloat(pow(relativeTime, 0.8)) * CGFloat.pi / 12
        let options: UIView.AnimationOptions = relativeTime.isZero ? .curveEaseInOut : .curveLinear
        UIView.animate(withDuration: 1, delay: 0, options: options, animations: { [weak self] in
            self?.playHeadImageView.rotate(by: angle)
        })
    }
    
    
    /// Изменение размера диска
    func set(scale: CGFloat, withDuration duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    

    /// Изменение состояния диска
    func set(state: State) {
        switch state {
            
        /// Анимация вращения диска
        case .play:
            setRotatingAnimation(to: discImageLayer, duration: 20, startAngle: discRotAngle, direction: 1)
            setRotatingAnimation(to: shine1ImageLayer, duration: 50, startAngle: shine1RotAngle, direction: 1)
            setRotatingAnimation(to: shine2ImageLayer, duration: 60, startAngle: shine2RotAngle,  direction: -1)
            setRotatingAnimation(to: coverImageView.layer, duration: 10, startAngle: coverRotAngle, direction: 1)
           
        /// Анимация остановки диска
        case .stop:
            coverRotAngle  = stopRotatingAnimation(at: coverImageView.layer)
            shine1RotAngle = stopRotatingAnimation(at: shine1ImageLayer)
            discRotAngle   = stopRotatingAnimation(at: discImageLayer)
            shine2RotAngle = stopRotatingAnimation(at: shine2ImageLayer)
        }
    }
    
    
    /// Остановка анимации вращения
    private func stopRotatingAnimation(at layer: CALayer) -> CGFloat {
        /// Сохранение текущего угла поворота
        let currentAngle = layer.presentation()?.value(forKeyPath: "transform.rotation") as? CGFloat ?? 0
        /// Удаление анимации
        layer.removeAllAnimations()
        /// Поворот на сохранённый угол
        layer.rotate(by: currentAngle)
        return currentAngle
    }
    
    
    /// Запуск анимации вращения
    private func setRotatingAnimation(to object: CALayer, duration: Double, startAngle: CGFloat, direction: CGFloat) {
        let animation            = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue      = startAngle
        animation.toValue        = startAngle + 2 * CGFloat.pi * direction
        animation.duration       = duration
        animation.repeatCount    = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        object.add(animation, forKey: "rotatingAnimation")
    }
    
    
    /// Состояние диска
    enum State {
        case stop
        case play
    }
}
