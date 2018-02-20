//
//  NameViewController.swift
//  ProjektZespolowy
//
//  Created by Lukasz Milaszewski on 09/05/17.
//  Copyright © 2017 Lukasz Milaszewski. All rights reserved.
//

import UIKit
import AudioToolbox

class NameViewController: UIViewController {
    
    var randomBoy: Int = 0
    var randomGirl: Int = 0
    
    @IBOutlet weak var boyLabel: UILabel!
    @IBOutlet weak var girlLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            randomBoy = Int(arc4random_uniform(UInt32(NameItem.boyNames.count)))
            randomGirl = Int(arc4random_uniform(UInt32(NameItem.girlNames.count)))
            
            //print("boys size: \(NameItem.boyNames.count)")
           // print("girls size: \(NameItem.girlNames.count)")
            boyLabel.text = NameItem.boyNames[randomBoy]
            girlLabel.text = NameItem.girlNames[randomGirl]
        }
    }
}
