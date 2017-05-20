//
//  TimerViewController.swift
//  ImpromptuMaster
//
//  Created by Mac on 5/18/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    var currentCount: Double = 0
    var maxCount: Double = 0
    var pickedTime = UserDefaults.standard.integer(forKey: "SpeechTimePicked") * 60
    var seconds = UserDefaults.standard.integer(forKey: "SpeechTimePicked") * 60
    var timer = Timer()
    var isTimerRunning = false
    var topicPassed : Topic?
    

    @IBOutlet weak var topicLabel: UILabel!
    
    @IBOutlet weak var timeBar: KDCircularProgress!
    
    @IBOutlet weak var timerButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topicLabel.text=topicPassed?.topicTitle
        timerLabel.text = timeString(time: TimeInterval(seconds))
        runTimer()
        self.isTimerRunning = true

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    
    @IBAction func timerTapped(_ sender: Any) {
        
        if self.isTimerRunning == false {
            runTimer()
           
            self.isTimerRunning = true
            timerButton.setImage(UIImage(named: "Timer Btn.png")!, for: UIControlState.normal)
        }

    }

    @IBAction func pauseTapped(_ sender: Any) {
        timer.invalidate()
        self.isTimerRunning = false
        timerButton.setImage(UIImage(named: "Light Blue Timer Btn.png")!, for: UIControlState.normal)
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        
        
        timer.invalidate()
        seconds = self.pickedTime
        timerLabel.text = timeString(time: TimeInterval(seconds))
        let newAngleValue = (360 * (self.pickedTime-seconds) / self.pickedTime)
        timeBar.animate(toAngle: Double(newAngleValue), duration: 0.5, completion: nil)
        isTimerRunning = false
        timerButton.setImage(UIImage(named: "Timer Btn.png")!, for: UIControlState.normal)
        
        
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TimerViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            self.isTimerRunning = false
            let newAngleValue = (360 * (self.pickedTime-seconds) / self.pickedTime)
            timeBar.animate(toAngle: Double(newAngleValue), duration: 0.5, completion: nil)
            
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
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
