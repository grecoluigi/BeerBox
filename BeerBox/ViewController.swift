//
//  ViewController.swift
//  BeerBox
//
//  Created by Luigi Greco on 06/04/22.
//

import UIKit

class ViewController: UIViewController, AlertDisplayer {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    private var viewModel: BeerViewModel!
    private var imageLoader = ImageLoader()
    private var isSearching = false
    private var lastPressedButton = Int()
    private let svButtons = ScrollViewButtons.shared.buttonNames
    private lazy var beerDetailVC: BeerDetailViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "BeerDetailViewController") as! BeerDetailViewController
        navigationController?.addChild(viewController)
            return viewController

    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        styleNavBarTitle()
        addFilterButtons()
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.keyboardDismissMode = .onDrag
        let request = BeerRequest(parameters: ["page": "1"])
        viewModel = BeerViewModel(request: request, delegate: self)
        viewModel.fetchBeers()
    }
    
    func addFilterButtons() {

       // let scrollView = UIScrollView(frame: CGRect(x: 0,y: 0, width: self.view.frame.width, height: 60))
        var frame : CGRect?
        let padding = 5
        var lastX = 10
  
        for i in 0..<svButtons.count {
            let button = UIButton(type: .roundedRect)
            let width = (svButtons[i].count * 10) + 10
            frame = CGRect(x: lastX, y: 10, width: width, height: 30)
                lastX += (width + padding)
            button.frame = frame!
            button.tag = i
            //button.backgroundColor = UIColor(named: "BeerAccent")
            button.backgroundColor = .darkText
            button.tintColor = .gray
            button.layer.cornerRadius = 15
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.addTarget(self, action: #selector(filterButton), for: .touchUpInside)
            button.setTitle(svButtons[i], for: .normal)
            scrollView.addSubview(button)
        }
        scrollView.contentSize = CGSize( width: CGFloat(lastX) + 20, height: scrollView.frame.size.height)

    }

    @objc func filterButton(sender: UIButton) {
        if lastPressedButton == sender.tag {
            viewModel.cancelSearch()
            sender.backgroundColor = .darkText
            sender.tintColor = .gray
            lastPressedButton = Int()
        } else {
            viewModel.fetchBeers()
            viewModel.filterBeers(by: ScrollViewButtons.shared.buttonAssociatedStrings[sender.tag])
        
            deselectAllButtons()
            sender.tintColor = .black
            sender.backgroundColor = UIColor(named: "BeerAccent")
            lastPressedButton = sender.tag
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func deselectAllButtons() {
        for button in scrollView.subviews {
            button.backgroundColor = .darkText
            button.tintColor = .gray
        }
    }
    
    func styleNavBarTitle() {
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Beer", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.light)])

        navTitle.append(NSMutableAttributedString(string: "Box", attributes:[
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0),
            NSAttributedString.Key.foregroundColor: UIColor.white]))

        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
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
            self.tableView.reloadData()
            self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
    }
    
    func onFetchFailed(with reason: String) {
      let title = "Errore"
      let action = UIAlertAction(title: "OK", style: .default)
      displayAlert(with: title , message: reason, actions: [action])
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
        cell.delegate = self
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

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deselectAllButtons()
        if searchText.isEmpty {
            viewModel.cancelSearch()
        } else {
            viewModel.filterBeers(by: searchText)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: BeerViewCellProtocol{
    func showBeerDetailSheet(beer: Beer) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let beerDetailVC = storyboard.instantiateViewController(withIdentifier: "BeerDetailViewController") as! BeerDetailViewController
        beerDetailVC.beer = beer
        beerDetailVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(beerDetailVC, animated: true)
    }
    
    
}

private extension ViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        if !viewModel.isInSearchMode {
            return indexPath.row >= viewModel.currentCount - 5
        } else {
            viewModel.fetchBeers()
            return false
        }
     }

     func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
       let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
       let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
       return Array(indexPathsIntersection)
     }
}

