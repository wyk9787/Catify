//
//  newCatViewController.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/6/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit

class newCatViewController: UIViewController,UITextFieldDelegate  {
    
    var newcatImage : UIImage?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        doneButton.isEnabled = false
    }
    
    // MARK: - Text Field Methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newcatSegue") {
            let DestVC = segue.destination as! ThankyouViewController
            DestVC.confirm = false
            DestVC.name = nameTextField.text!
        }
    }
    

}
