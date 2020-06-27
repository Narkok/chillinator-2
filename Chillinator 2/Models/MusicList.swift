//
//  MusicList.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 20/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

struct MusicList {
    
    /// Список композиций
    let list: [Music]
    
    /// Номер текущей композиции
    private(set) var currentNum: Int
    
    ///
    var isPlaying: Bool
    
    init(from data: [Music]) {
        list = data.shuffled()
        currentNum = 0
        isPlaying = false
    }

    
    /// Текущая композиция для исполнения
    func currentMusic() -> Music? {
        return list[safe: currentNum]
    }
    
    
    /// Сменить номер композиции
    mutating func changeMusic(by changeType: ChangeType) {
        switch changeType {
        case .setNext: currentNum = (currentNum + 1) % list.count
        case .set(let num): currentNum = num < list.count ? num : 0
        case .changeState: isPlaying = !isPlaying
        }
    }
    
    
    /// Сменить композицию
    enum ChangeType {
        /// Следующая по списку
        case setNext
        /// Композиция под номером
        case set(num: Int)
        ///
        case changeState
    }
}
