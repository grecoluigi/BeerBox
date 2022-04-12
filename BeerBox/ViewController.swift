//
//  ViewController.swift
//  BeerBox
//
//  Created by Luigi Greco on 06/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    private var viewModel: BeerViewModel!
    private var imageLoader = ImageLoader()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.prefetchDataSource = self

        let request = BeerRequest(parameters: ["page": "1"])
        viewModel = BeerViewModel(request: request, delegate: self)
        viewModel.fetchBeers()
        
    }
}

extension ViewController: BeerViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
      guard let newIndexPathsToReload = newIndexPathsToReload else {
//        indicatorView.stopAnimating()
          DispatchQueue.main.async {
              self.tableView.isHidden = false
              self.tableView.reloadData()
          }
       
        return
      }
    let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        DispatchQueue.main.async {
            print("Total count: \(self.viewModel.totalCount)")
            print("Table view rows: \(self.tableView.numberOfRows(inSection: 0))")
            self.tableView.reloadData()
            self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
     
       // tableView.reloadData()
        print(viewModel.totalCount)
    }
    
    func onFetchFailed(with reason: String) {
//      indicatorView.stopAnimating()
//
//      let title = "Warning".localizedString
//      let action = UIAlertAction(title: "OK".localizedString, style: .default)
//      displayAlert(with: title , message: reason, actions: [action])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell", for: indexPath) as! BeerTableViewCell
        if isLoadingCell(for: indexPath) {
              cell.configure(with: .none)
            } else {
                if let imageURL = viewModel.beer(at: indexPath.row).imageUrl {
                    imageLoader.obtainImageWithPath(imagePath: imageURL) { image in
                        cell.beerImageView.image = image
                    }
                }
              cell.configure(with: viewModel.beer(at: indexPath.row))
            }
        return cell
    }

}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

       if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchBeers()
         }
//        let needsFetch = indexPaths.contains { $0.row >= viewModel.totalCount }
//                if needsFetch {
//                    viewModel.fetchBeers()
//                }
    }

    
    
}

private extension ViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
       return indexPath.row >= viewModel.currentCount - 5
     }

     func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
       let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
       let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
       return Array(indexPathsIntersection)
     }
}
