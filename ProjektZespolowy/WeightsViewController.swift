//
//  AddWeight.swift
//  ProjektZespolowy
//
//  Created by Lukasz Milaszewski on 09/05/17.
//  Copyright © 2017 Lukasz Milaszewski. All rights reserved.
//

import UIKit

class WeightsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeightItem", for: indexPath)
        
        return cell
    }
}
