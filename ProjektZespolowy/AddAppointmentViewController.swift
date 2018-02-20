//
//  AddAppointmentViewController.swift
//  ProjektZespolowy
//
//  Created by Lukasz Milaszewski on 07/05/17.
//  Copyright © 2017 Lukasz Milaszewski. All rights reserved.
//

import UIKit
import UserNotifications

protocol AddAppointmentViewControllerDelegate: class {
    func addAppointmentViewControllerDidCancel(_ controller: AddAppointmentViewController)
    func addAppointmentViewController(_ controller: AddAppointmentViewController, didFinishAdding appointment: AppointmentItem)
    func addAppointmentViewController(_ controller: AddAppointmentViewController, didFinishEditing appointment: AppointmentItem)
}

class AddAppointmentViewController: UITableViewController, UITextFieldDelegate {
    
    weak var delegate: AddAppointmentViewControllerDelegate?
    var appointmentToEdit: AppointmentItem?
    var dueDate = Date()
    var datePickerVisible = false
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var doctorTextField: UITextField!
    @IBOutlet weak var questionsTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        typeTextField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
                granted, error in
            }
        }
    }
    
    @IBAction func cancel() {
        delegate?.addAppointmentViewControllerDidCancel(self)
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        if let appointment = appointmentToEdit {
            appointment.type = typeTextField.text!
            appointment.doctor = doctorTextField.text!
            appointment.questions = questionsTextField.text!
            appointment.descript = descriptionTextField.text!
            
            appointment.shouldRemind = shouldRemindSwitch.isOn
            appointment.dueDate = dueDate
            
            appointment.scheduleNotification()
            delegate?.addAppointmentViewController(self, didFinishEditing: appointment)
            
        } else {
            let appointment = AppointmentItem()
            appointment.type = typeTextField.text!
            appointment.doctor = doctorTextField.text!
            appointment.questions = questionsTextField.text!
            appointment.descript = descriptionTextField.text!
            
            appointment.shouldRemind = shouldRemindSwitch.isOn
            appointment.dueDate = dueDate
            
            appointment.scheduleNotification()
            delegate?.addAppointmentViewController(self, didFinishAdding: appointment)
        }
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeTextField.delegate = self
        doctorTextField.delegate = self
        questionsTextField.delegate = self
        descriptionTextField.delegate = self
        
        
        if let appointment = appointmentToEdit {
            title = "Edytuj wizyte"
            
            typeTextField.text = appointment.type
            doctorTextField.text = appointment.doctor
            questionsTextField.text = appointment.questions
            descriptionTextField.text = appointment.descript
            
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = appointment.shouldRemind
            dueDate = appointment.dueDate
        }
        updateDueDateLabel()
    }

    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDateRow = IndexPath(row: 1, section: 4)
        let indexPathDatePicker = IndexPath(row: 2, section: 4)
        //datePicker.becomeFirstResponder()
        
        
        //tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.middle, animated: true)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        let indexPath = IndexPath(row: 2, section: 4)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row: 1, section: 4)
            let indexPathDatePicker = IndexPath(row: 2, section: 4)
            /*
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            */
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
    // klawiatura przy typie wizyty
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        typeTextField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = typeTextField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
 
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 4 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        typeTextField.resignFirstResponder()
        
        if indexPath.section == 4 && indexPath.row == 1 {
            if !datePickerVisible {
        		showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 4 && indexPath.row == 1 {
            return indexPath
        } else {
        	return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 4 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
