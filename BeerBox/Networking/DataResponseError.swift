//
//  DataResponseError.swift
//  BeerBox
//
//  Created by Luigi Greco on 06/04/22.
//

import Foundation

enum DataResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "Network error"
        case .decoding:
            return "Error decoding the data"
        }
    }
}
