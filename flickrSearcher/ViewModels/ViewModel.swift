//
//  ViewModel.swift
//  flickrSearcher
//
//  Created by Vincent Palma on 2024-12-05.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var photos: [FlickrPhoto] = []
    @Published var isLoading: Bool = false
    
    private let apiService = APIService()
    
    @MainActor
    func searchPhotos() async {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Search text is empty. Aborting search.")
            return
        }

        isLoading = true

        do {
            let photos = try await apiService.fetchPhotos(searchText: searchText)
            if photos.isEmpty {
                print("No photos found for search text: \(searchText)")
            }
            self.photos = photos
        } catch {
            print("Error fetching photos: \(error.localizedDescription)")
        }

        isLoading = false
    }
}
