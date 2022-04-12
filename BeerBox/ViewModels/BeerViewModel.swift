//
//  BeerViewModel.swift
//  BeerBox
//
//  Created by Luigi Greco on 06/04/22.
//

import Foundation

protocol BeerViewModelDelegate: AnyObject {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class BeerViewModel {
    private weak var delegate : BeerViewModelDelegate?
    private var beers: [Beer] = []
    private var filteredBeers: [Beer] = []
    private var currentPage = 1
    private var total = 0
    private var reachedEndOfBeers = false
    private var isFetchInProgress = false
    private var isSearching = false
    
    let client = PunkClient()
    let request: BeerRequest
    
    init(request: BeerRequest, delegate: BeerViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    var isInSearchMode : Bool {
        return isSearching
    }
    
    var totalCount: Int {
        if !isSearching {
            return total
        } else {
            return filteredBeers.count
        }

    }
    
    var currentCount: Int {
        if !isSearching {
            return beers.count
        } else {
            return filteredBeers.count
        }
    
    }
    
    func beer(at index: Int) -> Beer {
        if !isSearching {
            return beers[index]
        } else {
            return filteredBeers[index]
        }

    }
    
    func cancelSearch() {
        isSearching = false
    }
    
    func filterBeers(by filter: String) {
        isSearching = true
        filteredBeers = beers
        filteredBeers = filteredBeers.filter({ (beer:Beer) -> Bool in
            
                    let nameMatch = beer.name!.range(of: filter, options: NSString.CompareOptions.caseInsensitive)
                    let taglineMatch = beer.tagline!.range(of: filter, options: NSString.CompareOptions.caseInsensitive)
                    let descriptionMatch = beer.description!.range(of: filter, options: NSString.CompareOptions.caseInsensitive)
                    return nameMatch != nil || taglineMatch != nil || descriptionMatch != nil}
                )
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
                    } else {
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
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newBeers: [Beer]) -> [IndexPath] {
        if !isSearching {
            let startIndex = beers.count - newBeers.count
            let endIndex = startIndex + newBeers.count
            return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}
        } else {
            let startIndex = filteredBeers.count - newBeers.count
            let endIndex = startIndex + newBeers.count
            return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}
        }
    }
}
