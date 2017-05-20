//
//  SettingsViewController.swift
//  ImpromptuMaster
//
//  Created by Mac on 5/16/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet var checkboxCollection: [UIButton]!
    @IBOutlet weak var switchRecording: UIButton!
    
    @IBOutlet weak var recordingOnOff: UILabel!
    
    var fromInitialToSettings : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in checkboxCollection{
            button.setImage(UIImage(named: "checkbox.png")!, for: UIControlState.normal)
            if (button.tag == UserDefaults.standard.integer(forKey: "SpeechTimePicked")){
                button.setImage(UIImage(named: "checkedcheckbox.png")!, for: UIControlState.normal)
            }
        }
        if (UserDefaults.standard.bool(forKey: "RecordingOn") == true){
            switchRecording.setImage(UIImage(named: "checkedSwitch.png")!, for: UIControlState.normal)
            recordingOnOff.text = "Recording is On"
        } else {
        switchRecording.setImage(UIImage(named: "uncheckedSwitch.png")!, for: UIControlState.normal)
            recordingOnOff.text = "Recording is Off"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkCheckbox(_ sender: UIButton ) {
        for button in checkboxCollection{
            button.setImage(UIImage(named: "checkbox.png")!, for: UIControlState.normal)
            if (button == sender){
                button.setImage(UIImage(named: "checkedcheckbox.png")!, for: UIControlState.normal)
            }
        }
        
        let defaults = UserDefaults.standard
        defaults.set(sender.tag, forKey: "SpeechTimePicked")
        
    }


    @IBAction func recordingSwitch(_ sender: UIButton) {
        

        if (UserDefaults.standard.bool(forKey: "RecordingOn") == true){
            
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "RecordingOn")
            
            sender.setImage(UIImage(named: "uncheckedSwitch.png")!, for: UIControlState.normal)
            
            recordingOnOff.text = "Recording is Off"
        }
        else{
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "RecordingOn")
            
            sender.setImage(UIImage(named: "checkedSwitch.png")!, for: UIControlState.normal)
            
            recordingOnOff.text = "Recording is On"
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        if fromInitialToSettings == true
        {
         performSegue(withIdentifier: "backToInitial", sender: self)
        }
        
        if fromInitialToSettings == false
        {
            performSegue(withIdentifier: "backToStart", sender: self)
        }
        
    
    }
    
    
}
