//
//  NetworkService.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import Foundation

// Сетевой сервис, который отвечает за выполнение сетевых запросов
struct NetworkService {

    // MARK: - Network Client
    let networkClient: NetworkClient

    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Fetch methods
    func fetchData() async throws -> [TaskOld] {
        let response = try await networkClient.fetchData(.dummy, type: JsonResponce.self)
        let tasksData = response.todos.map { $0.toTask() }
        return tasksData
    }

    func fetchDataFirstTime() async throws -> [TaskOld] {
        let response = try await networkClient.fetchData(.google, type: JsonResponce.self)
        let tasksData = response.todos.map { $0.toTask() }
        return tasksData
    }
}
