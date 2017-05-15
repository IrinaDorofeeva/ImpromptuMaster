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
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    
    @IBOutlet weak var topicLabel: UILabel!
    
    @IBOutlet weak var timeBar: KDCircularProgress!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var resetRec: UIButton!
    
    @IBOutlet weak var pauseRec: UIButton!
    
    @IBOutlet weak var startRec: UIButton!
    
    
    @IBOutlet weak var saveRec: UIButton!
    
    
    @IBOutlet weak var nextTopic: UIButton!
    
    
    @IBOutlet weak var pausePlay: UIButton!
    
    @IBOutlet weak var playPlay: UIButton!
    
    @IBOutlet weak var resetPlay: UIButton!
    
    var currentCount: Double = 0
    var maxCount: Double = 0
    var pickedTime = 60
    
    var seconds = 60 //This variable will hold a starting value of seconds. It could be any amount above 0.
    
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    //var resumeTapped = false
    var topicPassed = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveRec.isHidden=true
        nextTopic.isHidden=true
        pausePlay.isHidden=true
        playPlay.isHidden=true
        resetPlay.isHidden=true
        
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
        seconds = self.pickedTime   //Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant.
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
            
            //Send alert to indicate "time's up!"
            
            pauseRec.isHidden=true
            startRec.isHidden=true
            resetRec.isHidden=true
            
            saveRec.isHidden=false
            nextTopic.isHidden=false
            pausePlay.isHidden=false
            playPlay.isHidden=false
            resetPlay.isHidden=false
            
            
            
           
            pausePlay.isEnabled=false
            playPlay.isEnabled=true
            resetPlay.isEnabled=false
            
            
            //show different buttons
            
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
    
    
    
    
    func setupRecorder() {
        // Create an audio session
        do{
            let  session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            
            //Create URL for the audio file
            
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
           // print("#########################")
           // print(audioURL)
           // print("#########################")
         
            //Create settings for the audio recorder
            
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            //Create AudioRecorder object
            
            audioRecorder = try AVAudioRecorder (url: audioURL!,settings: settings)
            audioRecorder!.prepareToRecord()
            
        }
        catch let error as NSError {
            print(error)
        }
    }

    
    @IBAction func saveRecTapped(_ sender: Any) {
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
        
        let recordItem = NSEntityDescription.insertNewObject(forEntityName: "Record", into: managedObjectContext) as! Record
        
        recordItem.title=topicPassed
        recordItem.audio=NSData(contentsOf: audioURL!)
        
        print(recordItem)
        
               
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
        }
        
    }
    
   
    @IBAction func nextTopicTapped(_ sender: Any) {
    }
    
    
    @IBAction func pausePlayTapped(_ sender: Any) {
        
            audioPlayer!.pause()
        pausePlay.isEnabled=false
        playPlay.isEnabled=true
        resetPlay.isEnabled=true
        
    }
    
    
    @IBAction func playPlayTapped(_ sender: Any) {
        
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()

            pausePlay.isEnabled=true
            playPlay.isEnabled=false
            resetPlay.isEnabled=true
        }
        catch{}
        
    }
    
    @IBAction func resetPlayTaped(_ sender: Any) {
            audioPlayer!.stop()
        
        pausePlay.isEnabled=true
        playPlay.isEnabled=true
        resetPlay.isEnabled=false
    }
    
    
}
