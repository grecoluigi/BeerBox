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
    private var imageLoader = ImageLoader()
    @IBOutlet weak var beerTitleLabel: UILabel!
    @IBOutlet weak var beerTaglineLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerDescriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomSheetArea = bottomSheet.frame
        beerTitleLabel.text = beer.name
        beerTaglineLabel.text = beer.tagline
        beerDescriptionLabel.text = beer.description
        if let imageUrl = beer.imageUrl {
            imageLoader.obtainImageWithPath(imagePath: imageUrl) { image in
                self.beerImageView.image = image
            }
        }
        
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        let p = sender.location(in: self.view)
        if bottomSheetArea!.contains(p) {
            // inside
        } else {
            // outside
            self.dismiss(animated: true)
        }
        
    }
}
