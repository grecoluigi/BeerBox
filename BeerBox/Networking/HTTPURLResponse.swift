//
//  HTTPURLResponse.swift
//  BeerBox
//
//  Created by Luigi Greco on 06/04/22.
//

import Foundation

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
