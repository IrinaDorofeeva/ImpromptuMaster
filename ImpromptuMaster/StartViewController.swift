//
//  StartViewController.swift
//  ImpromptuMaster
//
//  Created by Mac on 5/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData

class StartViewController: UIViewController {
    
    @IBOutlet weak var topicLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var hintButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var introLabel: UILabel!
    
    
    var topicItems : [Topic] = []
    var shownTopic : Topic?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
            do {
                topicItems = try managedObjectContext.fetch(fetchRequest) as! [Topic]
            } catch {
               
            }
            
        }
        
        let randNum = arc4random_uniform(UInt32(topicItems.count))
    
        shownTopic=topicItems[Int(randNum)]
        topicLabel.text=shownTopic?.topicTitle
        topicLabel.isHidden=true
        introLabel.isHidden=false
        
        
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        if introLabel.isHidden==true {
            
            let randNum = arc4random_uniform(UInt32(topicItems.count))
            shownTopic=topicItems[Int(randNum)]
            topicLabel.text=shownTopic?.topicTitle
           
        }
    }
    
    @IBAction func hintTapped(_ sender: Any) {
        if introLabel.isHidden==true {
            performSegue(withIdentifier: "hintPopup", sender: self)
            
        }
    }
    
    @IBAction func startTapped(_ sender: Any) {
        
        switch introLabel.isHidden{
        case false:
            topicLabel.isHidden=false
            introLabel.isHidden=true
            startButton.setImage(UIImage(named: "Go Red Btn.png")!, for: UIControlState.normal)
            
        case true:
            if UserDefaults.standard.bool(forKey: "RecordingOn") == true
            {
                performSegue(withIdentifier: "startRecording", sender: self)}
            else {
            performSegue(withIdentifier: "toTimer", sender: self)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startRecording" {
            let destinationVC = segue.destination as! RecordViewController
            destinationVC.topicPassed=shownTopic
        } else if segue.identifier == "backToInitial" {
        }
        else if segue.identifier == "hintPopup" {
            let destinationVC = segue.destination as! HintPopupViewController
            destinationVC.topicPassed=shownTopic
        }
        
        else if segue.identifier == "fromStartToSettings" {
            let destinationVC = segue.destination as! SettingsViewController
            destinationVC.fromInitialToSettings=false
        }
        else if segue.identifier == "toTimer" {
            let destinationVC = segue.destination as! TimerViewController
            destinationVC.topicPassed=shownTopic
        }


        
    }
}
