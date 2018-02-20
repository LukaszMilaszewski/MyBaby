//
//  functions.swift
//  ProjektZespolowy
//
//  Created by Lukasz Milaszewski on 05/05/17.
//  Copyright © 2017 Lukasz Milaszewski. All rights reserved.
//

import UIKit

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()

var photoURL: URL {
    let filename = "MotherPhoto.jpg"
   // print( (applicationDocumentsDirectory.appendingPathComponent(filename)))
    return applicationDocumentsDirectory.appendingPathComponent(filename)
}

var photoImage: UIImage? {
        return UIImage(contentsOfFile: (photoURL.path))
}
