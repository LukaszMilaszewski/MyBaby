//
//  AppointmentsViewController.swift
//  ProjektZespolowy
//
//  Created by Lukasz Milaszewski on 06/05/17.
//  Copyright © 2017 Lukasz Milaszewski. All rights reserved.
//

import UIKit

class AppointmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddAppointmentViewControllerDelegate {
    
    var appointments: [AppointmentItem]
    
    @IBOutlet var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
      
        appointments = [AppointmentItem]()
        
    	super.init(coder: aDecoder)
        loadAppointments()
        registerDefaults()

      //  print("Documents folder: \(documentsDirectory())")
      //  print("Data file path: \(dataFilePath())")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    	
        
    }
    
    class func nextItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ItemID")
        userDefaults.set(itemID + 1, forKey: "ItemID")
        userDefaults.synchronize()
        return itemID
    }
    
    func registerDefaults() {
        let dictionary: [String: Any] = ["ChecklistItemID" : 0]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func sortAppointments() {
        //appointments.sort(by: { appointment1, appointment2 in return appointment1.dueDate.compare(appointment2.dueDate) == .orderedAscending })
        
        appointments.sort(by: { $0.dueDate.compare($1.dueDate) == .orderedAscending})
    }
    
    // deklaracja metod z protokolu AddAppointments
    
    
    func addAppointmentViewControllerDidCancel(_ controller: AddAppointmentViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addAppointmentViewController(_ controller: AddAppointmentViewController, didFinishAdding appointment: AppointmentItem) {
       
        appointments.append(appointment)
        sortAppointments()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        saveAppointments()
        
        /*
        let newRowIndex = appointments.count
        appointments.append(appointment)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        */
    }
    
    func addAppointmentViewController(_ controller: AddAppointmentViewController, didFinishEditing appointment: AppointmentItem) {
        
        sortAppointments()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        saveAppointments()
        
        /*
         if let index = appointments.index(of: appointment) {
         let indexPath = IndexPath(row: index, section: 0)
         if let cell = tableView.cellForRow(at: indexPath) {
         configureText(for: cell, with: appointment)
         }
         }
         */
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAppointment" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddAppointmentViewController
            controller.delegate = self
        } else if segue.identifier == "EditAppointment" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddAppointmentViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            	controller.appointmentToEdit = appointments[indexPath.row]
            }
        }
    }
    
    // metody dla tableView
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        appointments.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveAppointments()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentItem", for: indexPath)

        let appointment = appointments[indexPath.row]
        configureText(for: cell, with: appointment)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureText(for cell: UITableViewCell, with appointment: AppointmentItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = appointment.type
        
        let date = cell.viewWithTag(2000) as! UILabel
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        date.text = formatter.string(from: appointment.dueDate)
        //label.text = "\(appointment.itemID): \(appointment.type)"
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    	return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("ProjektZespolowy.plist")
    }
    
    func saveAppointments() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(appointments, forKey: "Appointments")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadAppointments() {
        
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            appointments = unarchiver.decodeObject(forKey: "Appointments") as! [AppointmentItem]
            unarchiver.finishDecoding()
        }
        
        sortAppointments()
    }
}
