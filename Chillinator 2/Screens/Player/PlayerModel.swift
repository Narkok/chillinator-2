//
//  PlayerModel.swift
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
    
    init(from data: [Music]) {
        list = data.shuffled()
        currentNum = 0
    }

    
    /// Получить копрозицию для исполнения
    func getMusic() -> Music {
        print(list[currentNum])
        return list[currentNum]
    }
    
    
    /// Сменить номер композиции
    mutating func changeMusic(by changeType: ChangeType) {
        switch changeType {
        case .setNext: currentNum = (currentNum + 1) % list.count
        case .set(let num): currentNum = num < list.count ? num : 0 }
    }
    
    
    /// Сменить композицию
    enum ChangeType {
        /// Следующая по списку
        case setNext
        /// Композиция под номером
        case set(num: Int)
    }
}
