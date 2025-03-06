//
//  DI.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import Foundation

final class DependencyContainer {

    let interactor: Interactor
    let startManager: AppStartManager
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let session: URLSession
    let networkClient: NetworkClient
    let networkService: NetworkService
    let router: AppRouter
    let coreDataManager: CoreDataManager

    init() {
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        session = URLSession(configuration: .default)
        interactor = Interactor()

        networkClient = NetworkClient(decoder: decoder, encoder: encoder, session: session)
        networkService = NetworkService(networkClient: networkClient)

        router = AppRouter()

        coreDataManager = CoreDataManager()

        startManager = AppStartManager(interactor: interactor, networkService: networkService, router: router, coreDataManager: coreDataManager)

    }
}
