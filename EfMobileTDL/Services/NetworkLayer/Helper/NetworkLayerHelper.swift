//
//  NetworkLayerHelper.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import Foundation

// Обработка ошибок
enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case httpError(Int)
    case noData
    case decodingError(Error)
    case unknown(Error)
}

// Методы
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// Точки доступа
enum BaseURL: String {
    case dummy =  "https://dummyjson.com/todos"
    case start = "https://drive.google.com/uc?export=download&id=1MXypRbK2CS9fqPhTtPonn580h1sHUs2W"
}

enum endPoint {
    case google
    case dummy

    var url: URL? {
        switch self {
        case .dummy: return URL(string: BaseURL.dummy.rawValue)
        case .google: return URL(string: BaseURL.start.rawValue)
        }
    }
}
