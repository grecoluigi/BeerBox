//
//  BeerDetailViewController.swift
//  BeerBox
//
//  Created by Luigi Greco on 12/04/22.
//

import UIKit

class BeerDetailViewController: UIViewController {
    @IBOutlet weak var bottomSheet: UIView!
    var bottomSheetArea: CGRect?
    var beer: Beer!
    @IBOutlet weak var backgroundView: UIView!
    private var imageLoader = ImageLoader()
    @IBOutlet weak var beerTitleLabel: UILabel!
    @IBOutlet weak var beerTaglineLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerDescriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomSheetArea = bottomSheet.bounds
        beerTitleLabel.text = beer.name
        beerTaglineLabel.text = beer.tagline
        beerDescriptionLabel.text = beer.description
        if let imageUrl = beer.imageUrl {
            imageLoader.obtainImageWithPath(imagePath: imageUrl) { image in
                self.beerImageView.image = image
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animateBackgroundView(isAppearing: true)
    }
    
    
    func animateBackgroundView(isAppearing : Bool){
        UIView.transition(with: backgroundView, duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
            if isAppearing{
                self.backgroundView.alpha = 0.5
            } else {
                self.backgroundView.alpha = 0
            }
               
        }) { finished in
            if !isAppearing {
                self.dismiss(animated: true)
            }
        }
    }

    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        let p = sender.location(in: self.view)
        // If the user is tapping outside the bottom frame then dismiss the controller
        if !bottomSheet.frame.contains(p) {
            animateBackgroundView(isAppearing: false)
        }
    }
}
