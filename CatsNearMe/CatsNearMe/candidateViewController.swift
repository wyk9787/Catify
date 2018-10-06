//
//  candidateViewController.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/6/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit

class candidateViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var candidateTableView: UITableView!
    
    var candidates : [Cat] = []
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        candidates = []
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        capturedImage.image = result!
        candidateTableView.delegate = self
        candidateTableView.dataSource = self
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "candidatecell", for: indexPath) as! CandidateTableViewCell
        cell.nameLabel.text = candidates[indexPath.row].name
        cell.imageView!.image = candidates[indexPath.row].images[0]
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "candidateSegue") {
            let indexPath = self.candidateTableView.indexPath(for: sender as! CatTableViewCell)
            let row = indexPath?.row
            let DestVC = segue.destination as! DetailViewController
            DestVC.cat = candidates[row!]
            
            DestVC.imageView.image = candidates[row!].images[0]
            DestVC.nameLabel.text = candidates[row!].name
            DestVC.colorLabel.text = candidates[row!].color
            DestVC.breedLabel.text = candidates[row!].breed
            DestVC.ownerLabel.text = "Owner: "+candidates[row!].owner
            if candidates[row!].neutered {
                DestVC.neuteredLbel.text = "Neutered"
            } else {
                DestVC.neuteredLbel.text = "Not neutered"
            }
            DestVC.contactButton.isHidden = true
            DestVC.confirmButton.isHidden = false

            DestVC.lat = lat
            DestVC.lon = lon
        }
        if (segue.identifier == "createcatSegue") {
            let DestVC = segue.destination as! newCatViewController
            DestVC.newcatImage = capturedImage.image
            DestVC.lat = lat
            DestVC.lon = lon
        }
    }
}
