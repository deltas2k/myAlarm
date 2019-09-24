//
//  AlarmDetailTableViewController.swift
//  myAlarm
//
//  Created by Matthew O'Connor on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateView()
        }
    }
    
    var alarmIsOn: Bool = true
    
    @IBOutlet weak var alarmPicker: UIDatePicker!
    @IBOutlet weak var alarmName: UITextField!
    @IBOutlet weak var enablebutton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    
    @IBAction func enableButtonTapper(_ sender: Any) {
        guard let alarm = alarm else {return}
        AlarmController.shared.toggleEnable(alarm: alarm)
        alarmIsOn = alarm.enabled
        updateView()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let nameText = alarmName.text else {return}
        if let alarm = alarm {
            AlarmController.shared.updateAlarm(alarm: alarm, fireDate: alarmPicker.date, name: nameText, enable: alarmIsOn)
        } else {
            AlarmController.shared.addAlarm(fireDate: alarmPicker.date, name: nameText, enable: alarmIsOn)
        }
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }

private func updateView() {
    guard let alarm = alarm else { return }
        alarmPicker.date = alarm.fireDate
        alarmName.text = alarm.name
        
        enablebutton.isHidden = false
        if alarm.enabled {
            enablebutton.setTitle("Disable", for: UIControl.State.normal)
            enablebutton.backgroundColor = .red
            enablebutton.setTitleColor(.white, for: UIControl.State.normal)
        } else {
            enablebutton.setTitle("Enable", for: UIControl.State.normal)
            enablebutton.backgroundColor = .lightGray
            enablebutton.setTitleColor(.black, for: UIControl.State.normal)
            }
        self.title = alarm.name
        }
    }

