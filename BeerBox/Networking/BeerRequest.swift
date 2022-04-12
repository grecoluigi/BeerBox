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
//    private init(parameters: Parameters) {
//        self.parameters = parameters
//    }
    
 

}

// forse non mi serve?
//extension BeerRequest {
//    static func from(site: String) -> BeerRequest {
//        let defaultParameters = [String: String]()
//        let parameters = ["site"
//    }
//}
