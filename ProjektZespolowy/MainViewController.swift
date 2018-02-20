//
//  MainViewController.swift
//  ProjektZespolowy
//
//  Created by Lukasz Milaszewski on 26/04/17.
//  Copyright © 2017 Lukasz Milaszewski. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var name: String?
    var time: Int?
    var pregnancyProgress: Float = 0
    var pregnancyWeekDuration: Int = 40
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        
        obtainMotherData()
        setLabels()
        setPhotoViews()
        setProgressView()
        super.viewDidLoad()
        
    }
    
    
    func obtainMotherData() {
        name = UserDefaults.standard.string(forKey: "PregnancyName")
        time = UserDefaults.standard.integer(forKey: "PregnancyTime")
    }
    
    func setLabels() {
        nameLabel.text = "Witaj \(name!). \nJestes w \(time!) tygodniu ciazy."
    }
    
    func setPhotoViews() {
        photoView.image = photoImage
        photoView.layer.cornerRadius = photoView.frame.size.width/2
        photoView.clipsToBounds = true
    }
    
    func setProgressView() {
        pregnancyProgress = Float (Float(time!) / Float(pregnancyWeekDuration))
        //print("\(pregnancyProgress)")
        progressView.setProgress(pregnancyProgress, animated: true)
    }
}
