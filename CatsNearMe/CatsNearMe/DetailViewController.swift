//
//  DetailViewController.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/6/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var cat : Cat?
    var candidate = false

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var neuteredLbel: UILabel!
    
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func contactButtonTapped(_ sender: Any) {
        let phoneString = "telprompt://4693187380"
        UIApplication.shared.open((URL(string: phoneString))!, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = cat!.images[0]
        self.nameLabel.text = "Name: "+cat!.name
        self.colorLabel.text = "Color: "+cat!.color
        self.breedLabel.text = "Breed: "+cat!.breed
        self.ownerLabel.text = "Owner: "+cat!.owner
        if cat!.neutered {
            neuteredLbel.text = "Neutered"
        } else {
            neuteredLbel.text = "Not neutered"
        }
        if candidate {
            self.contactButton.isHidden = true
            self.confirmButton.isHidden = false
        } else {
            self.contactButton.isHidden = false
            self.confirmButton.isHidden = true
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "confirmSegue") {
            let DestVC = segue.destination as! ThankyouViewController
            DestVC.confirm = true
            DestVC.id = (cat?.id)!
        }
        
        if (segue.identifier == "mapSegue") {
            let DestVC = segue.destination as! MapViewController
            DestVC.locations = (cat?.locations)!
            DestVC.center = (cat?.center)!
            DestVC.name = cat?.name
        }
    }
    
}
