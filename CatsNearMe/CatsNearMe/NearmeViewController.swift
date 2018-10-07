//
//  NearmeViewController.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/6/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit

class NearmeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cats : [Cat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        Cat.allcats(lon: lon, lat: lat) { (cats) in
            self.cats = cats
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catcell", for: indexPath) as! CatTableViewCell
        cell.nameLabel.text = cats[indexPath.row].name
        cell.breedLabel.text = cats[indexPath.row].breed
        cell.ownerLabel.text = "Owner: "+cats[indexPath.row].owner

        cell.catImageView!.image = cats[indexPath.row].images[0]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            let indexPath = self.tableView.indexPath(for: sender as! CatTableViewCell)
            let row = indexPath?.row
            let DestVC = segue.destination as! DetailViewController
            DestVC.cat = cats[row!]
            DestVC.candidate = false
        }
    }
}
