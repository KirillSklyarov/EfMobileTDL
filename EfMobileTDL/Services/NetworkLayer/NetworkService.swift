//
//  NetworkService.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchDataFromServer() async throws -> [TDLItem]
    func fetchDataFirstTime() async throws -> [TDLItem]
}

struct NetworkService: NetworkServiceProtocol {

    // MARK: - Network Client
    let networkClient: NetworkClient

    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Fetch methods
    func fetchDataFromServer() async throws -> [TDLItem] {
        let response = try await networkClient.fetchData(.dummy, type: JsonResponse.self)
        let tasksData = responseMapping(response)
        return tasksData
    }

    func fetchDataFirstTime() async throws -> [TDLItem] {
        let response = try await networkClient.fetchData(.google, type: JsonResponse.self)
        let tasksData = responseMapping(response)
        return tasksData
    }
}

// MARK: - Supporting methods
private extension NetworkService {
    func responseMapping(_ response: JsonResponse) -> [TDLItem] {
        return response.todos.map { $0.toTask() }
    }
}
