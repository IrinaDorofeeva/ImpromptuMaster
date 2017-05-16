//
//  RecordViewController.swift
//  ImpromptuMaster
//
//  Created by Mac on 5/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//
import AVFoundation
import UIKit
import CoreData

class RecordViewController: UIViewController {
    
    
    
    var audioRecorder : AVAudioRecorder?
    var audioURL : URL?

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var timeBar: KDCircularProgress!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resetRec: UIButton!
    @IBOutlet weak var pauseRec: UIButton!
    @IBOutlet weak var startRec: UIButton!
   
    
    var currentCount: Double = 0
    var maxCount: Double = 0
    var pickedTime = 20
    
    var seconds = 20 //This variable will hold a starting value of seconds.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var topicPassed = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topicLabel.text=topicPassed
        setupRecorder()
        timeLabel.text = timeString(time: TimeInterval(seconds))
        runTimer()
        audioRecorder?.record()
        self.isTimerRunning = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        audioRecorder?.stop()
    }
    
    @IBAction func pauseRecTapped(_ sender: Any) {
        timer.invalidate()
        audioRecorder?.pause()
        self.isTimerRunning = false
        startRec.setImage(UIImage(named: "Record Btn.png")!, for: UIControlState.normal)
    }
    
    @IBAction func startRecTapped(_ sender: Any) {
        if self.isTimerRunning == false {
            runTimer()
            audioRecorder?.record()
            self.isTimerRunning = true
            startRec.setImage(UIImage(named: "Record Red.png")!, for: UIControlState.normal)
        }
    }
    
    
    @IBAction func resetRecTapped(_ sender: Any) {
        timer.invalidate()
        audioRecorder?.stop()
        seconds = self.pickedTime
        timeLabel.text = timeString(time: TimeInterval(seconds))
        let newAngleValue = (360 * (self.pickedTime-seconds) / self.pickedTime)
        timeBar.animate(toAngle: Double(newAngleValue), duration: 0.5, completion: nil)
        isTimerRunning = false
        startRec.setImage(UIImage(named: "Record Btn.png")!, for: UIControlState.normal)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(RecordViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            audioRecorder?.stop()
            performSegue(withIdentifier: "playAndSave", sender: self)
            self.isTimerRunning = false
            let newAngleValue = (360 * (self.pickedTime-seconds) / self.pickedTime)
            timeBar.animate(toAngle: Double(newAngleValue), duration: 0.5, completion: nil)
            
        } else {
            seconds -= 1
            timeLabel.text = timeString(time: TimeInterval(seconds))
            let newAngleValue = (360 * (self.pickedTime-seconds) / self.pickedTime)
            timeBar.animate(toAngle: Double(newAngleValue), duration: 0.5, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playAndSave" {
            let destinationVC = segue.destination as! PlayAndSaveViewController
            destinationVC.topicPassed=topicPassed
            destinationVC.audioURL = audioURL
        } else if segue.identifier == "backToStart" {
        }
    }

    
    func timeString(time:TimeInterval) -> String {
        // let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    
    func setupRecorder() {
            do{
            let  session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            audioRecorder = try AVAudioRecorder (url: audioURL!,settings: settings)
            audioRecorder!.prepareToRecord()
        }
        catch let error as NSError {
            print(error)
        }
    }


    
    
}
