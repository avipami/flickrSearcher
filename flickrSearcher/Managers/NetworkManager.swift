//
//  NetworkManager.swift
//  flickrSearcher
//
//  Created by Vincent Palma on 2024-12-05.
//

import Foundation

class APIService {
    private let baseURL = "https://www.flickr.com/services/rest/"
    private let yourKey: String? = nil  // <-- Replace nil with your " API key "
    
    func getAPIKey() -> String? {
        if yourKey != nil {
            return yourKey
        }
        
        if let key = ProcessInfo.processInfo.environment["FLICKR_KEY"] {
            return key.decode()
        }
        return nil
    }
    
    func fetchPhotos(searchText: String) async throws -> [FlickrPhoto] {
        guard let url = makeSearchURL(searchText: searchText) else {
            throw URLError(.badURL)
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let flickrResponse = try JSONDecoder().decode(FlickrResponse.self, from: data)
            
            let validPhotos = flickrResponse.photos.photo.filter {
                $0.farm > 0 && !$0.server.isEmpty && !$0.secret.isEmpty
            }
            
            if validPhotos.isEmpty {
                print("No valid photos found for search text: \(searchText)")
            }
            
            return validPhotos
        } catch {
            print("Error during fetch: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func makeSearchURL(searchText: String) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: getAPIKey()),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "text", value: searchText),
            URLQueryItem(name: "per_page", value: "20")
        ]
        return components?.url
    }
}
