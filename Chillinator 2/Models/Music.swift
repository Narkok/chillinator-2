//
//  Music.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 27/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import Foundation


/// Композиция
struct Music: Codable, Equatable {
    
    /// Заголовок
    let title: String?
    
    /// Исполнитель
    let artist: String?
    
    /// URL обложки композиции
    let coverURL: String?
    
    /// URL композиции
    private let musicURL: String?

    var getMusicURL: URL? {
        guard let musicURL = musicURL else { return nil }
        return URL(string: musicURL)
    }
}
