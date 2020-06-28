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
    
    @IBOutlet weak var disk: Disk!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    var viewModel: PlayerViewModel?
    
    private var playerItem: AVPlayerItem?
    private let player = AVPlayer()
    
    private let disposeBag = DisposeBag()
    
    
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
        /// Инициализация плеера
        view.layer.addSublayer(AVPlayerLayer(player: player))
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
        
        
        /// Кнопка списка композиций
        listButton.rx.tap
            .bind(to: viewModel.input.showList)
            .disposed(by: disposeBag)
        
        
        /// Установка обложки
        viewModel.output.music
            .map { $0.coverURL ?? "" }
            .drive(disk.rx.coverImage)
            .disposed(by: disposeBag)
        
        
        /// Установка заголовка
        viewModel.output.music
            .map { $0.title }
            .delay(.milliseconds(200))
            .drive(titleLabel.rx.smoothChangeText)
            .disposed(by: disposeBag)
        
        
        /// Установка исполнителя
        viewModel.output.music
            .map { $0.artist }
            .delay(.milliseconds(400))
            .drive(artistLabel.rx.smoothChangeText)
            .disposed(by: disposeBag)
        
        
        /// Установка новой песни в плеер
        viewModel.output.music
            .map { $0.getMusicURL }
            .filterNil()
            .map { AVPlayerItem(url: $0) }
            .drive(player.rx.playerItem)
            .disposed(by: disposeBag)
        
        
        /// Запуск / остановка плеера
        viewModel.output.isPlaying
            .drive(player.rx.play)
            .disposed(by: disposeBag)
        
        
        /// Сменить картинку на кнопке
        viewModel.output.isPlaying
            .distinctUntilChanged()
            .map { UIImage(named: $0 ? "pauseButton" : "playButton") }
            .drive(playButton.rx.image())
            .disposed(by: disposeBag)
        
        
        /// Запуск / остановка диска
        viewModel.output.isPlaying
            .distinctUntilChanged()
            .drive(disk.rx.isPlaying)
            .disposed(by: disposeBag)
        
        
        /// Изменение положения головки проигрывателя
        player.rx.relativeTimer
            .distinctUntilChanged()
            .bind(to: disk.rx.playHeadPosition)
            .disposed(by: disposeBag)
        
        
        /// Запуск следующей композиции по окончанию текущей
        player.rx.currentItem
            .filterNil()
            .distinctUntilChanged()
            .flatMapLatest { $0.rx.didPlayToEnd }
            .map { .setNext }
            .bind(to: viewModel.input.change)
            .disposed(by: disposeBag)
        

        /// Открыть контроллер со списком композиций
        viewModel.output.openList
            .drive(onNext:{ [weak self] musicList in
                let mlController = MusicListViewController()
                mlController.modalPresentationStyle = .formSheet
                mlController.viewModel = MusicListViewModel(data: musicList)
                self?.present(mlController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
