//
//  AppointmentItem.swift
//  ProjektZespolowy
//
//  Created by Lukasz Milaszewski on 07/05/17.
//  Copyright © 2017 Lukasz Milaszewski. All rights reserved.
//

import UIKit
import UserNotifications

class AppointmentItem: NSObject, NSCoding {
    var type = ""
    var doctor = ""
    var questions = ""
    var descript = ""
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    required init?(coder aDecoder: NSCoder) {
        type = aDecoder.decodeObject(forKey: "Type") as! String
        doctor = aDecoder.decodeObject(forKey: "Doctor") as! String
        questions = aDecoder.decodeObject(forKey: "Questions") as! String
        descript = aDecoder.decodeObject(forKey: "Descript") as! String
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
    
    
    override init() {
        itemID = AppointmentsViewController.nextItemID()
        super.init()
    }
    
    deinit {
        removeNotification()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: "Type")
        aCoder.encode(doctor, forKey: "Doctor")
        aCoder.encode(questions, forKey: "Questions")
        aCoder.encode(descript, forKey: "Descript")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
          //  let content = UNMutableNotificationContent()
            let content = UNMutableNotificationContent()
            content.title = "Przypomnienie:"
            content.body = type
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest( identifier: "\(itemID)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Schedule notif \(request) for itemID: \(itemID)")
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
}

