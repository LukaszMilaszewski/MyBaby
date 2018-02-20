//
//  ViewController.swift
//  ProjektZespolowy
//
//  Created by Lukasz Milaszewski on 26/04/17.
//  Copyright © 2017 Lukasz Milaszewski. All rights reserved.
//

import UIKit

class ChooseAppViewController: UIViewController {
    
    @IBAction func pregnant() {
    	// powinno byc ==
        if UserDefaults.standard.bool(forKey: "PregnantFirstRun") == false {
        	performSegue(withIdentifier: "ConfigurationPregnant", sender: nil)
        } else {
            performSegue(withIdentifier: "Pregnant", sender: nil)
        }
    }
    
    @IBAction func child() {
        performSegue(withIdentifier: "ConfigurationChild", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

