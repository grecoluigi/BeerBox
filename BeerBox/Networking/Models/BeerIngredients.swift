//
// BeerIngredients.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct BeerIngredients: Codable { 


    public var malt: [Malt]?
    public var hops: [Hope]?
    public var yeast: String?

    public init(malt: [Malt]?, hops: [Hope]?, yeast: String?) {
        self.malt = malt
        self.hops = hops
        self.yeast = yeast
    }

}