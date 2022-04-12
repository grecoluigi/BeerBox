//
//  BeerRequest.swift
//  BeerBox
//
//  Created by Luigi Greco on 06/04/22.
//

import Foundation

struct BeerRequest {
    var path: String {
        return "beers"
    }
    

    let parameters: Parameters
    init(parameters: Parameters) {
        self.parameters = parameters
    }
}
