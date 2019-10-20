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
    
    private let discImageView     = UIImageView()
    private let shine1ImageView   = UIImageView()
    private let coverImageView    = UIImageView()
    private let shine2ImageView   = UIImageView()
    private let pipkaImageView    = UIImageView()
    private let playHeadImageView = UIImageView()

    private var shine1RotAngle = CGFloat.random(in: -CGFloat.pi...CGFloat.pi)
    private var shine2RotAngle = CGFloat.random(in: -CGFloat.pi...CGFloat.pi)
    private var discRotAngle   = CGFloat.random(in: -CGFloat.pi...CGFloat.pi)
    private var coverRotAngle  = CGFloat.zero
    
    override func draw(_ rect: CGRect) {
        self.addSubview(discImageView)
        self.addSubview(shine1ImageView)
        self.addSubview(shine2ImageView)
        self.addSubview(coverImageView)
        self.addSubview(pipkaImageView)
        self.addSubview(playHeadImageView)
        
        /// Установка фона диска
        discImageView.image     = backgroundImage
        discImageView.bounds    = CGRect(x: 0, y: 0, width: size, height: size)
        discImageView.rotate(by: discRotAngle)
        discImageView.layer.shadowColor   = UIColor.black.cgColor
        discImageView.layer.shadowRadius  = 15
        discImageView.layer.shadowOpacity = 0.7
        
        /// Установка бликов
        shine1ImageView.image     = shineImage
        shine1ImageView.bounds    = CGRect(x: 0, y: 0, width: size, height: size)
        shine1ImageView.rotate(by: shine1RotAngle)
        
        shine2ImageView.image     = shineImage
        shine2ImageView.bounds    = CGRect(x: 0, y: 0, width: size, height: size)
        shine2ImageView.rotate(by: shine2RotAngle)
        
        /// Установка обложки песни
        let coverImageSize           = Int(Double(size) * 0.4)
        coverImageView.clipsToBounds = true
        coverImageView.bounds        = CGRect(x: 0, y: 0, width: coverImageSize, height: coverImageSize)
        coverImageView.layer.cornerRadius = CGFloat(coverImageSize)/2
        
        /// Установка центральной оси
        pipkaImageView.layer.allowsEdgeAntialiasing = true
        pipkaImageView.bounds = CGRect(x: 0, y: 0, width: size / 35, height: size / 35)
        pipkaImageView.clipsToBounds = true
        pipkaImageView.layer.cornerRadius = size / 70
        pipkaImageView.image = pipkaImage
        
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
    
    
    /// Анимированная установка новой обложки
    func setCover(url: String){
        let duration = 0.4
        /// Затемнить обложку
        coverImageView.fadeOut(withDuration: duration)
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [unowned self] _ in
            guard let coverURL = URL(string: url) else { return }
            /// Загрузить новую обложку
            self.coverImageView.kf.setImage(with: coverURL) { [unowned self] _ in
                /// Показать новую обложку
                self.coverImageView.fadeIn(withDuration: duration)
            }
        }
    }
    
    
    /// Установка позиции головки проигрывателя от времени
    func setPlayHeadPosition(relativeTime: CGFloat) {
        let angle = (relativeTime - 1) * CGFloat.pi / 12
        UIView.animate(withDuration: 1) { [unowned self] in
            self.playHeadImageView.rotate(by: angle)
        }
    }
    

    /// Изменение состояния диска
    func setState(_ newState: State) {
        switch newState {
            
        /// Анимация вращения диска
        case .start:
            setRotatingAnimation(to: discImageView, duration: 20, startAngle: discRotAngle, direction: 1)
            setRotatingAnimation(to: coverImageView, duration: 10, startAngle: coverRotAngle, direction: 1)
            setRotatingAnimation(to: shine1ImageView, duration: 50, startAngle: shine1RotAngle, direction: 1)
            setRotatingAnimation(to: shine2ImageView, duration: 60, startAngle: shine2RotAngle,  direction: -1)
           
        /// Анимация остановки диска
        case .stop:
            coverRotAngle  = stopRotatingAnimation(at: coverImageView)
            shine1RotAngle = stopRotatingAnimation(at: shine1ImageView)
            discRotAngle   = stopRotatingAnimation(at: discImageView)
            shine2RotAngle = stopRotatingAnimation(at: shine2ImageView)
        }
    }
    
    
    /// Остановка анимации вращения
    private func stopRotatingAnimation(at object: UIView) -> CGFloat {
        /// Сохранение текущего угла поворота
        let rotAngle = object.layer.presentation()?.value(forKeyPath: "transform.rotation") as! CGFloat
        /// Удаление анимации
        object.layer.removeAllAnimations()
        /// Поворот на сохранённый угол
        object.rotate(by: rotAngle)
        return rotAngle
    }
    
    
    /// Запуск анимации вращения
    private func setRotatingAnimation(to object: UIView, duration: Double, startAngle: CGFloat, direction: CGFloat) {
        let animation            = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue      = startAngle
        animation.toValue        = startAngle + 2 * CGFloat.pi * direction
        animation.duration       = duration
        animation.repeatCount    = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        object.layer.add(animation, forKey: "rotatingAnimation")
    }
    
    
    /// Состояние диска
    enum State {
        case stop
        case start
    }
}
