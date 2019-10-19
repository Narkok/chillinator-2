//
//  PlayerViewModel.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 18/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlayerViewModel {
    
    private static let musicListService = MusicListService()

    init() {
        
        /// Получить список песен
        let musicList = PlayerViewModel.musicListService.getList().map { $0.element ?? [] }

        
    }
    
}
