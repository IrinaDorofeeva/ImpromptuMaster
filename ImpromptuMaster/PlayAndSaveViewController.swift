//
//  PlayAndSaveViewController.swift
//  ImpromptuMaster
//
//  Created by Mac on 5/15/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class PlayAndSaveViewController: UIViewController {

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var timeBar: KDCircularProgress!
    @IBOutlet weak var timeLabel: UILabel!    
    @IBOutlet weak var saveRec: UIButton!
    @IBOutlet weak var nextTopic: UIButton!
    @IBOutlet weak var pausePlay: UIButton!
    @IBOutlet weak var playPlay: UIButton!
    @IBOutlet weak var resetPlay: UIButton!
    
    var currentCount: Double = 0
    var maxCount: Double = 0
    var pickedTime = UserDefaults.standard.integer(forKey: "SpeechTimePicked") * 60
    var seconds = UserDefaults.standard.integer(forKey: "SpeechTimePicked") * 60
    var timer = Timer()
    var isTimerRunning = false
    var audioURL : URL?
    var audioPlayer : AVAudioPlayer?
    var topicPassed : Topic?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topicLabel.text=topicPassed?.topicTitle
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        audioPlayer?.stop()
    }
    
    @IBAction func saveRecordTapped(_ sender: Any) {
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            let recordItem = NSEntityDescription.insertNewObject(forEntityName: "Record", into: managedObjectContext) as! Record
            recordItem.title=topicPassed?.topicTitle
            recordItem.audio=NSData(contentsOf: audioURL!)
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            recordItem.date=formatter.string(from: date)
            
            let asset = AVURLAsset(url: audioURL!, options: nil)
            let audioDuration = asset.duration
            recordItem.duration = Double(CMTimeGetSeconds(audioDuration))
            
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
        //  go to saved rec view here
        performSegue(withIdentifier: "savedRec", sender: self)
    }
    
    
    func duration(for resource: String) -> Int {
        let asset = AVURLAsset(url: URL(fileURLWithPath: resource))
        return Int(CMTimeGetSeconds(asset.duration))
    }
    
    @IBAction func nextTopicTapped(_ sender: Any) {
        performSegue(withIdentifier: "nextTopic", sender: self)
    }
    
    
    @IBAction func pausePlayTapped(_ sender: Any) {
        
        timer.invalidate()
        self.isTimerRunning = false
        audioPlayer?.pause()
    }
    
    
    @IBAction func playPlayTapped(_ sender: Any) {
        if self.isTimerRunning == false {
            runTimer()
            do{
                try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
                audioPlayer!.play()
            }
            catch{}
            self.isTimerRunning = true
        }
    }
    
    @IBAction func resetPlayTapped(_ sender: Any) {
        timer.invalidate()
        audioPlayer?.stop()
        seconds = self.pickedTime
        timeLabel.text = timeString(time: TimeInterval(seconds))
        let newAngleValue = (360 * (self.pickedTime-seconds) / self.pickedTime)
        timeBar.animate(toAngle: Double(newAngleValue), duration: 0.5, completion: nil)
        isTimerRunning = false
    }
    
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(PlayAndSaveViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            audioPlayer?.stop()
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



}
