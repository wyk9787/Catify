//
//  candidateViewController.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/6/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit

class candidateViewController: UIViewController {
    
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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
