//
//  RecordViewController.swift
//  ImpromptuMaster
//
//  Created by Mac on 5/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    @IBOutlet weak var timeBar: KDCircularProgress!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var resetRec: UIButton!
    
    @IBOutlet weak var pauseRec: UIButton!
    
    @IBOutlet weak var startRec: UIButton!
    
    
    var currentCount: Double = 0
    var maxCount: Double = 0
    var pickedTime = 120
    
    var seconds = 120 //This variable will hold a starting value of seconds. It could be any amount above 0.
    
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    //var resumeTapped = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeBar.angle = 0
        timeLabel.text = timeString(time: TimeInterval(seconds))
        runTimer()
        self.isTimerRunning = true
    }
    
    @IBAction func pauseRecTapped(_ sender: Any) {
        timer.invalidate()
        self.isTimerRunning = false
    }
    
    @IBAction func startRecTapped(_ sender: Any) {
        
        if self.isTimerRunning == false {
            runTimer()
            self.isTimerRunning = true
        }
        
    }
    
    
    @IBAction func resetRecTapped(_ sender: Any) {
        
        timer.invalidate()
        seconds = self.pickedTime   //Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant.
        timeLabel.text = timeString(time: TimeInterval(seconds))
        let newAngleValue = (360 * (self.pickedTime-seconds) / self.pickedTime)
        timeBar.animate(toAngle: Double(newAngleValue), duration: 0.5, completion: nil)
        isTimerRunning = false
        
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(RecordViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate "time's up!"
        } else {
            seconds -= 1
            timeLabel.text = timeString(time: TimeInterval(seconds))
            let newAngleValue = (360 * (self.pickedTime-seconds) / self.pickedTime)
            
            timeBar.animate(toAngle: Double(newAngleValue), duration: 0.5, completion: nil)
        }
    }
    func timeString(time:TimeInterval) -> String {
        // let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    
    
    
    
}
