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
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var disk: Disk!
    @IBOutlet weak var diskLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var diskTopConstraint: NSLayoutConstraint!
    
    var viewModel: PlayerViewModel?
    
    private var initialTopConstraint  = CGFloat()
    private var initialLeftConstraint = CGFloat()
    
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
        
        initialTopConstraint  = diskTopConstraint.constant
        initialLeftConstraint = diskLeftConstraint.constant
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
        

        /// Открыть контроллер со списком композиций
        viewModel.output.openList
            .drive(onNext:{ [weak self] player in self?.openList(with: player) })
            .disposed(by: disposeBag)
    }
    
    
    /// Открыть контроллер списка композиций
    private func openList(with player: Player) {
        let mlController = MusicListViewController()
        mlController.modalPresentationStyle = .overFullScreen
        mlController.modalTransitionStyle = .coverVertical
        mlController.viewModel = MusicListViewModel(data: player)
        present(mlController, animated: false)
        
        let duration = 0.5
        let scale: CGFloat = 0.6
        
        /// Уменьшить диск при открытии списка
        disk.set(scale: scale, withDuration: duration)
        /// Переместить диск в центр и повыше
        UIView.animate(withDuration: duration) { [weak self]  in
            guard let self = self else { return }
            let diskSize = self.disk.bounds.width / 2
            self.diskTopConstraint.constant  = 140 - diskSize * (1 - scale)
            self.diskLeftConstraint.constant = self.view.bounds.width / 2 - diskSize * (1 - scale)
            self.view.layoutIfNeeded()
        }
        
        mlController.rx.viewWillDisappear.asDriver().drive(onNext:{ [weak self]  in
            /// Вернуть размер диска
            self?.disk.set(scale: 1, withDuration: duration)
            /// Вернуть диск в начальное положение
            UIView.animate(withDuration: duration) { [weak self]  in
                guard let self = self else { return }
                self.diskTopConstraint.constant  = self.initialTopConstraint
                self.diskLeftConstraint.constant = self.initialLeftConstraint
                self.view.layoutIfNeeded()
            }
        }).disposed(by: disposeBag)
    }
}
