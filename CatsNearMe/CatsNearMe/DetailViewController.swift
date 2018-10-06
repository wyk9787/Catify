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
    
    var lon : Double = 0
    var lat : Double = 0

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

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "confirmSegue") {
            let DestVC = segue.destination as! ThankyouViewController
            DestVC.thankyouLabel.text = "Confirming..."
            Cat.confirm(id: cat!.id, lon: lon, lat: lat) { (success) in
                if success {
                    DestVC.thankyouLabel.text = "Thank you!"
                } else {
                    DestVC.thankyouLabel.text = "Sorry failed to confirm this cat."
                }
            }
        }
        
        if (segue.identifier == "mapSegue") {
            let DestVC = segue.destination as! MapViewController
            DestVC.locations = (cat?.locations)!
            DestVC.center = (cat?.center)!
            DestVC.name = cat?.name
        }
    }
    
}
