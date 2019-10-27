//
//  Music.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 27/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import Foundation


/// Структура песни
struct Music: Codable, Equatable {
    
    private let title: String?
    private let artist: String?
    private let coverURL: String?
    private let musicURL: String?
    
    /// URL обложки композиции
    var getCoverURL: String { return coverURL ?? "" }
    
    /// URL композиции
    var getMusicURL: URL? {
        guard let musicURL = musicURL else { return nil }
        return URL(string: musicURL)
    }
}
