//
//  Player.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 20/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//


/// 
struct Player {
    
    /// Список композиций
    let list: [Music]
    
    /// Номер текущей композиции
    private(set) var currentNum: Int
    
    /// Состояние
    var isPlaying: Bool
    
    init(with data: [Music]) {
        list = data.shuffled()
        currentNum = 0
        isPlaying = false
    }

    
    /// Текущая композиция для исполнения
    func currentMusic() -> Music? {
        return list[safe: currentNum]
    }
    
    
    /// Сменить номер композиции
    mutating func change(by changeType: Change) {
        switch changeType {
        case .setNext: currentNum = (currentNum + 1) % list.count
        case .setNum(let num): currentNum = num < list.count ? num : 0
        case .changeState: isPlaying = !isPlaying
        case .setMusic(let music): currentNum = list.firstIndex(of: music) ?? 0
        }
    }
    
    
    /// Сменить композицию
    enum Change {
        /// Поставить следующую по списку
        case setNext
        /// Поставить композицию под номером
        case setNum(Int)
        /// Изменить состояние (Play / Pause)
        case changeState
        /// Поставить композицию
        case setMusic(Music)
    }
}
