//
//  FlickrResponse.swift
//  flickrSearcher
//
//  Created by Vincent Palma on 2024-12-05.
//

import Foundation

struct FlickrResponse: Codable, Equatable {
    static func == (lhs: FlickrResponse, rhs: FlickrResponse) -> Bool {
        return lhs.photos == rhs.photos
    }
    
    let photos: PhotoData
}

struct PhotoData: Codable, Equatable {
    let photo: [FlickrPhoto]
}

struct FlickrPhoto: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let farm: Int
    let server: String
    let secret: String
    
    var thumbnailURL: URL? {
            guard farm > 0 else { return nil }
            return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg")
        }
}
