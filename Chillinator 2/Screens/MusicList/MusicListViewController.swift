//
//  MusicListViewController.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 22/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MusicListViewController: UIViewController {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MusicListViewModel?

    private let disposeBag = DisposeBag()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Убрать бегунок со слайдера
        slider.setThumbImage(UIImage(), for: .normal)
        
        /// Настройка подписок
        setupSubscriptions()
        
        /// Анимированое открытие списка
        openList()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        /// Событие начала закрытия списка
        viewModel?.input.view.willClose.accept(())
        
        /// Анимированное закрытие списка
        closeList()
    }
    
    
    /// Настройка подписок
    private func setupSubscriptions() {
        guard let viewModel = viewModel else { return }
        
        /// Сменить картинку на кнопке
        viewModel.output.view.isPlaying
            .distinctUntilChanged()
            .map { UIImage(named: $0 ? "pauseButton" : "playButton") }
            .drive(playButton.rx.image())
            .disposed(by: disposeBag)
        
        /// Установка заголовка
        viewModel.output.view.music
            .map { $0.title }
            .drive(titleLabel.rx.smoothChangeText)
            .disposed(by: disposeBag)
        
        /// Установка исполнителя
        viewModel.output.view.music
            .map { $0.artist }
            .delay(.milliseconds(100))
            .drive(artistLabel.rx.smoothChangeText)
            .disposed(by: disposeBag)
        
        /// Полоска проигрывания
        viewModel.output.view.relativeTimer
            .drive(slider.rx.value)
            .disposed(by: disposeBag)
        
        /// Загрузка списка в tableView
        viewModel.output.view.list
            .drive(tableView.rx.items) { tableView, _, music in tableView.cell(forClass: MusicCell.self) ~ { $0.set(music) } }
            .disposed(by: disposeBag)
        
        /// Запуск выбранной из списка композиции
        tableView.rx.modelSelected(Music.self)
            .map { Player.Change.setMusic($0) }
            .bind(to: viewModel.input.view.change)
            .disposed(by: disposeBag)
            
        /// Остановка / проигрывание композиции
        playButton.rx.tap.map { .changeState }
            .bind(to: viewModel.input.view.change)
            .disposed(by: disposeBag)
    }
    
    
    /// Открыть список композиций
    private func openList() {
        heightConstraint.constant = 550
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    
    /// Скрыть список композиций
    private func closeList() {
        heightConstraint.constant += 10
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] _ in
            self?.heightConstraint.constant = 0
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }) { [weak self] _ in self?.dismiss(animated: false) }
        }
    }
}
