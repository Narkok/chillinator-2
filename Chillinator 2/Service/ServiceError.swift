//
//  ServiceError.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 28.06.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//


/// Типы ошибок
enum ServiceError: Error {
    case error(message: String)
    case requestError
    case decodingError
    
    var message: String {
        switch self {
        case .error(let message):
            return message
        case .requestError:
            return "Ошибка при запросе данных"
        case .decodingError:
            return "Ошибка парсинга данных"
        }
    }
}
