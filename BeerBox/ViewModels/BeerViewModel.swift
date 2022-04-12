//
//  BeerViewModel.swift
//  BeerBox
//
//  Created by Luigi Greco on 06/04/22.
//

import Foundation

protocol BeerViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class BeerViewModel {
    private weak var delegate : BeerViewModelDelegate?
    private var beers: [Beer] = []
    private var currentPage = 1
    private var total = 0
    private var reachedEndOfBeers = false
    private var isFetchInProgress = false

    
    let client = PunkClient()
    let request: BeerRequest
    
    init(request: BeerRequest, delegate: BeerViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    var totalCount: Int {
       return total
    }
    
    var currentCount: Int {
        return beers.count
    }
    
    func beer(at index: Int) -> Beer {
        return beers[index]
    }
    
    func fetchBeers() {
        guard !isFetchInProgress else {
            return
        }
        
        guard !reachedEndOfBeers else {
            return
        }
        
        isFetchInProgress = true
        client.fetchBeers(with: request, page: currentPage) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    if response.isEmpty {
                        self.reachedEndOfBeers = true
                        print("No more beers to load!")
                        // I reached the end, so I can set the total count
                    } else {
                        // there's still beers to load
                        self.currentPage += 1
                        self.isFetchInProgress = false
                        self.beers.append(contentsOf: response)
                        self.total = self.beers.count
                        if self.currentPage > 1 {
                            let indexPathToReload = self.calculateIndexPathsToReload(from: response)
                            self.delegate?.onFetchCompleted(with: indexPathToReload)
                        } else {
                            self.delegate?.onFetchCompleted(with: .none)
                        }
                        
                    }
                    //self.beers.append(response)
//                    if response.page > 1 {
//                      let indexPathToReload = self.calculateIndexPathsToReload(from: response.moderators)
//                      self.delegate?.onFetchCompleted(with: indexPathToReload)
//                    } else {
//                      self.delegate?.onFetchCompleted(with: .none)
//                    }
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newBeers: [Beer]) -> [IndexPath] {
      let startIndex = beers.count - newBeers.count
      let endIndex = startIndex + newBeers.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}
    }
}
