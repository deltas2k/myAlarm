//
//  AlarmController.swift
//  myAlarm
//
//  Created by Matthew O'Connor on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

protocol AlarmScheduler: class {
//    func scheduleUserNotification()
//    func cancelUserNotifications()
    
}

extension AlarmScheduler {
    func scheduleUserNotification(for Alarm: Alarm) {
        let scheduleUserNote = UNMutableNotificationContent()
        scheduleUserNote.title = "Alarm Notification"
        scheduleUserNote.body = "Your alarm is going off"
        scheduleUserNote.sound = .default
        
        let userNotificationIdentifier = "TimerNotification"
        let dateComponents = Calendar.current.dateComponents([.minute, .second], from: Alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: userNotificationIdentifier, content: scheduleUserNote, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func cancelLocalnotification(for alarm: Alarm) {
        let userNotificationIdentifier = "TimerNotification"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [userNotificationIdentifier])
    }
}

class AlarmController: AlarmScheduler {
    
    static let shared = AlarmController()
    
    var myAlarms: [Alarm] = []
    
    //CRUD
    func addAlarm(fireDate: Date, name: String, enable: Bool) {
        let newAlarm = Alarm(fireDate: fireDate, name: name)
        myAlarms.append(newAlarm)
        saveToPersistentStorage()
    }
    
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enable: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        saveToPersistentStorage()
    }
    
    func delete(alarm: Alarm) {
        guard let alarmDeleted = myAlarms.firstIndex(of: alarm) else {return}
            myAlarms.remove(at: alarmDeleted)
        saveToPersistentStorage()
        }
    
    func toggleEnable(alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
            scheduleUserNotification(for: alarm)
        } else {
            cancelLocalnotification(for: alarm)
        }
    }

    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "alarm.json"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    
    func saveToPersistentStorage() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonAlarm = try jsonEncoder.encode(myAlarms)
            try jsonAlarm.write(to: fileURL())
        } catch {
            //handle the error if there is one
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    func loadFromPersistentStorage() {
        let jsonDecoder = JSONDecoder()
        do {
            //try to create a DATA object from whatever lives at that file location
            let jsonData = try Data(contentsOf: fileURL())
            //try to create an array of playlist objects from the data we just created
            let decodedAlarmArray = try jsonDecoder.decode([Alarm].self, from: jsonData)
            myAlarms = decodedAlarmArray
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
}
    

