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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh), for: UIControl.Event.valueChanged)
        self.candidateTableView.refreshControl = refreshControl
    }
    
    @objc func refresh() {
        self.candidateTableView.reloadData()
        self.candidateTableView.refreshControl?.endRefreshing()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "candidateSegue") {
            let indexPath = self.candidateTableView.indexPath(for: sender as! CandidateTableViewCell)
            let row = indexPath?.row
            let DestVC = segue.destination as! DetailViewController
            DestVC.cat = candidates[row!]
            DestVC.candidate = true
        }
        if (segue.identifier == "createcatSegue") {
            let nav = segue.destination as! UINavigationController
            let DestVC = nav.topViewController as! newCatViewController
            DestVC.newcatImage = capturedImage.image
        }
    }
}
