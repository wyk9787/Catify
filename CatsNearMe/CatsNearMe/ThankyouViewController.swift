//
//  ThankyouViewController.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/6/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit

class ThankyouViewController: UIViewController {
    
    var confirm = false
    var id = -1
    var name = ""
    
    @IBOutlet weak var thankyouLabel: UILabel!
    
    @IBAction func okayButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func refresh(success : Bool) -> Void {
        if success {
            self.thankyouLabel.text = "Thank you!"
        } else {
            self.thankyouLabel.text = "Sorry failed to finish this task."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if confirm {
            self.thankyouLabel.text = "Confirming..."
        } else {
            self.thankyouLabel.text = "Adding cat..."
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if confirm {
            Cat.confirm(id: id) { (success) in
                DispatchQueue.main.async {
                    self.refresh(success: success)
                }
            }
        } else {
            Cat.newcat(name: name) { (success) in
                DispatchQueue.main.async {
                    self.refresh(success: success)
                }
            }
        }
        
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
