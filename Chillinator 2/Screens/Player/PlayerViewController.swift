//
//  PlayerViewController.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 18/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import AVFoundation


class PlayerViewController: UIViewController {
    
    var viewModel: PlayerViewModel?
    
    let player = AVPlayer()
    let disposeBag = DisposeBag()
    
    /// Вынести в viewModel, а то стремно как-то тут держать
    private var onPlaying = false
    
    @IBOutlet weak var disk: Disk!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Настройка экрана
        setupView()
        
        /// Настройка плеера
        setupPlayer()
        
        /// Настройка подписок
        setupSubscriptions()
    }
    
    
    /// Настройка экрана
    private func setupView() {
        view.alpha = 0
        view.fadeIn()
        view.sendSubviewToBack(disk)
    }
    
    
    /// Настройка плеера
    private func setupPlayer() {
        /// Продолжать играть в фоновом режиме
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        /// Инициализация плеера
        let playerLayer = AVPlayerLayer(player: player)
        view.layer.addSublayer(playerLayer)
    }
    
    
    /// Настройка подписок
    private func setupSubscriptions() {
        guard let viewModel = viewModel else { return }
        
        
        /// Кнопка 'next'
        nextButton.rx.tap.map { .setNext }
            .bind(to: viewModel.input.change)
            .disposed(by: disposeBag)
        
        
        /// Кнопка 'play/pause'
        playButton.rx.tap
            .bind(to: viewModel.input.play)
            .disposed(by: disposeBag)
        
        
        /// Настройка композиции
        viewModel.output.music.subscribe(onNext:{ [unowned self] music in
            
            /// Установка обложки
            self.disk.setCover(coverURL: music.getCoverURL)
            
            /// Установка новой песни в плеер
            guard let url = URL(string: music.getMusicURL) else { return }
            let playerItem = RxPlayerItem(url: url)
            self.player.replaceCurrentItem(with: playerItem)
            if self.onPlaying { self.player.play() }

            /// Запуск следующей песни по окончанию текущей
            playerItem.didPlayToEndTime.map { .setNext }
                .bind(to: viewModel.input.change)
                .disposed(by: playerItem.disposeBag)

        }).disposed(by: disposeBag)
        
        
        /// Остановка/проигрывание композиции
        playButton.rx.tap.asDriver().drive(onNext:{ [unowned self] in
            self.onPlaying = !self.onPlaying
            if self.onPlaying {
                self.player.play()
                self.playButton.setImage(UIImage(named: "pauseButton"), for: .normal)
                self.disk.setState(.start)
            }
            else {
                self.player.pause()
                self.playButton.setImage(UIImage(named: "playButton"), for: .normal)
                self.disk.setState(.stop)
            }
        }).disposed(by: disposeBag)
        

        /// Открыть контроллер со списком композиций
        listButton.rx.tap.withLatestFrom(viewModel.output.musicList)
            .subscribe(onNext: { [unowned self] musicList in
                let mlController = MusicListViewController()
                mlController.viewModel = MusicListViewModel(data: musicList)
                self.present(mlController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        
        /// Изменение положения головки проигрывателя
        player.rx.relativeTimer
            .bind(to: disk.rx.playHeadPosition)
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        disk.setPlayHeadPosition(relativeTime: 0)
    }
}
