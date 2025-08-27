//
//  NetworkLayerClient.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import Foundation

struct NetworkClient: Sendable {

    // MARK: - Properties
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let session: URLSession

    // MARK: - Init
    init(decoder: JSONDecoder, encoder: JSONEncoder, session: URLSession) {
        self.decoder = decoder
        self.encoder = encoder
        self.session = session
    }

    // MARK: - Methods
    func fetchData<T: Codable>(_ typeOfData: endPoint, type: T.Type) async throws -> T {
        guard let url = typeOfData.url else {
            Log.networkLayer.errorAlways("Can't create URL")
            throw NetworkError.invalidURL
        }

        let request = URLRequest(url: url)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            Log.networkLayer.errorAlways("Invalid HTTP response")
            throw NetworkError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            Log.networkLayer.errorAlways("Invalid response status code: \(httpResponse.statusCode)")
            throw NetworkError.httpError(httpResponse.statusCode)
        }

        do {
            let fetchedData = try self.decoder.decode(T.self, from: data)
            return fetchedData
        } catch {
            Log.networkLayer.errorAlways("Error decoding data: \(error)")
            throw NetworkError.decodingError(error)
        }
    }
}
