//
//  TimerViewController.swift
//  Fit
//
//  Created by Irakli Grigolia on 6/19/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit
import UserNotifications

class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

  @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var TimerPickerView: UIPickerView!
    
    
    
    let resume = "Resume"
    let pause = "Pause"
    var hour:Int = 0
    var minutes:Int = 0
    var seconds1:Int = 0
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    
    
    var seconds = 0
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
    
    
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if isTimerRunning == false {
            seconds = (max(0,TimerPickerView.selectedRow(inComponent: 0)*3600)) + (max(0,TimerPickerView.selectedRow(inComponent: 1)*60)) + max(0,TimerPickerView.selectedRow(inComponent: 2))
            runTimer()
            self.startButton.isEnabled = true
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isTimerRunning = true
        pauseButton.isEnabled = true
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
            self.pauseButton.setTitle(resume, for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            self.pauseButton.setTitle(pause, for: .normal)
        }
    }
    
    @objc func background(noti: Notification) {
        if isTimerRunning == true{
        while seconds > 0{
           
        seconds -= 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
        print("im am in background")
        }
        
        
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Heyoo"
            notificationContent.subtitle = "Time is up!"
            notificationContent.body = "You can enjoy your meals now!"
            notificationContent.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(
            identifier: "SimplifiediOSNotification", content: notificationContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
    }
    
  
        
    
   
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        timer.invalidate()
        seconds = 0
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        pauseButton.isEnabled = false
    }
    
    
  
    
    @objc func updateTimer() {
        if isTimerRunning == true {
        if seconds < 1 {
            
            
            timer.invalidate()
            print("stoping timer...")
            
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Heyoo"
            notificationContent.subtitle = "Time is up!"
            notificationContent.body = "You can enjoy your meals now!"
            notificationContent.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(
            identifier: "SimplifiediOSNotification", content: notificationContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
        print("going...")
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    

    
    
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
    func refresh (hours: Int, mins: Int, secs: Int) -> Int {
        self.hour -= hours
        self.minutes -= mins
        self.seconds1 -= secs
        seconds = (hour * 3600) + (minutes * 60) + seconds1
        return seconds
        
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        
        notificationCenter.addObserver(self, selector: #selector(background), name: UIApplication.didEnterBackgroundNotification, object: nil)


        
        
        pauseButton.isEnabled = false
        TimerPickerView.delegate = self
        TimerPickerView.dataSource = self
        
        

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }

}

extension TimerViewController{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1,2:
            return 60
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) Hour"
        case 1:
            return "\(row) Minute"
        case 2:
            return "\(row) Second"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = row
        case 1:
            minutes = row
        case 2:
            seconds1 = row
        default:
            break;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}

