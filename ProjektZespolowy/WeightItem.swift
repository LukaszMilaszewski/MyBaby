//
//  WeightItem.swift
//  ProjektZespolowy
//
//  Created by Lukasz Milaszewski on 09/05/17.
//  Copyright © 2017 Lukasz Milaszewski. All rights reserved.
//

import UIKit

class WeightItem: NSObject, NSCoding {
    var weight: Double = 0
    var date = Date()
    
    required init?(coder aDecoder: NSCoder) {
        weight = aDecoder.decodeDouble(forKey: "Weight")
        date = aDecoder.decodeObject(forKey: "Date") as! Date
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(weight, forKey: "Weight")
        aCoder.encode(date, forKey: "Date")
    }
}
