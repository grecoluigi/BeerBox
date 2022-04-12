//
//  BeerTableViewCell.swift
//  BeerBox
//
//  Created by Luigi Greco on 08/04/22.
//

import UIKit

class BeerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerTaglineLabel: UILabel!
    @IBOutlet weak var beerDescriptionLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    
    func configure(with beer: Beer?) {
        if let beer = beer {
            beerNameLabel.text = beer.name
            beerTaglineLabel.text = beer.tagline
            beerDescriptionLabel.text = beer.description
        }
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      
      configure(with: .none)
    }
}
