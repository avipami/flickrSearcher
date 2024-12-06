//
//  Helpers.swift
//  flickrSearcher
//
//  Created by Vincent Palma on 2024-12-05.
//

import Foundation
import SwiftUICore

extension View {
    func padding(_ edges: Edge.Set = .all, _ size: PaddingSize) -> some View {
        self.padding(edges, size.rawValue)
    }
}

extension String {
    
    func decode() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum PaddingSize : CGFloat {
    case small = 4
    case medium = 8
    case large = 16
}
