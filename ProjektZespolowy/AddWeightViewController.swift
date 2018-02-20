//
//  AddWeightViewController.swift
//  ProjektZespolowy
//
//  Created by Lukasz Milaszewski on 09/05/17.
//  Copyright © 2017 Lukasz Milaszewski. All rights reserved.
//

import UIKit

class AddWeightViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
       // weightTextField.becomeFirstResponder()
        super.viewDidLoad()
    }
}
