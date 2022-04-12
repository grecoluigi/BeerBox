//
//  Result.swift
//  BeerBox
//
//  Created by Luigi Greco on 06/04/22.
//

import Foundation

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}
