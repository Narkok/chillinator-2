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
    
    @IBOutlet weak var disk: Disk!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Продолжать играть в фоновом режиме
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        /// Настройка экрана
        setupView()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        /// Инициализация плеера
        view.layer.addSublayer(AVPlayerLayer(player: player))
        disk.setPlayHeadPosition(relativeTime: 0)
    }
    
    
    /// Настройка подписок
    private func setupSubscriptions() {
        guard let viewModel = viewModel else { return }
        
        /// Кнопка 'next'
        nextButton.rx.tap.map { .setNext }
            .bind(to: viewModel.input.change)
            .disposed(by: disposeBag)
        
        
        /// Остановка / проигрывание композиции
        playButton.rx.tap.map { .changeState }
            .bind(to: viewModel.input.change)
            .disposed(by: disposeBag)
        
        
        /// Установка обложки
        viewModel.output.music.map { $0.getCoverURL }
            .bind(to: disk.rx.coverImage)
            .disposed(by: disposeBag)
        
        
        /// Запуск следующей песни по окончанию текущей
//        viewModel.output.music.subscribe(onNext:{ [unowned self] music in
//            playerItem.didPlayToEndTime.map { .setNext }
//                .bind(to: viewModel.input.change)
//                .disposed(by: playerItem.disposeBag)
//        }).disposed(by: disposeBag)
        
        
        /// Установка новой песни в плеер
        viewModel.output.music.map { $0.getMusicURL }.filter { $0 != nil }.map { $0! }
            .map { RxPlayerItem(url: $0) }
            .bind(to: player.rx.playerItem)
            .disposed(by: disposeBag)
        
        
        /// Запуск / остановка плеера
        viewModel.output.isPlaying
            .bind(to: player.rx.play)
            .disposed(by: disposeBag)
        
        
        /// Сменить картинку на кнопке
        viewModel.output.isPlaying
            .map { UIImage(named: $0 ? "pauseButton" : "playButton") }
            .bind(to: playButton.rx.image())
            .disposed(by: disposeBag)
        
        
        /// Запуск / остановка диска
        viewModel.output.isPlaying
            .bind(to: disk.rx.isPlaying)
            .disposed(by: disposeBag)
        
        
        /// Изменение положения головки проигрывателя
        player.rx.relativeTimer
            .bind(to: disk.rx.playHeadPosition)
            .disposed(by: disposeBag)
        

        /// Открыть контроллер со списком композиций
        listButton.rx.tap.withLatestFrom(viewModel.output.musicList)
            .subscribe(onNext: { [unowned self] musicList in
                let mlController = MusicListViewController()
                mlController.viewModel = MusicListViewModel(data: musicList)
                self.present(mlController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

