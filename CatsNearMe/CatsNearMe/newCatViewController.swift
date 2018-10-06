//
//  newCatViewController.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/6/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit

class newCatViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {
    
    var newcatImage : UIImage?
    var lon : Double = 0
    var lat : Double = 0
    var selectedColor = "black"
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var colorPickerView: UIPickerView!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPickerView.delegate = self
        colorPickerView.dataSource = self
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
    
    // MARK: - Picker View Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColor = colors[row]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newcatSegue") {
            let DestVC = segue.destination as! ThankyouViewController
            DestVC.thankyouLabel.text = "Adding cat..."
            Cat.newcat(name: nameTextField.text!, color: selectedColor, lon: lon, lat: lat) { (success) in
                if success {
                    DestVC.thankyouLabel.text = "Thank you!"
                } else {
                    DestVC.thankyouLabel.text = "Sorry failed to add this cat."
                }
            }
        }
    }
    

}
