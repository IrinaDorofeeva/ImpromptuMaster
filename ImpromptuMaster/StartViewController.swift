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
    
    
  
    
    
    
    var topicItems : [Topic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
            do {
                topicItems = try managedObjectContext.fetch(fetchRequest) as! [Topic]
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
            
        }
        
        let randNum = arc4random_uniform(UInt32(topicItems.count))
        
        
        topicLabel.text=topicItems[Int(randNum)].topicTitle
        
   
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        let randNum = arc4random_uniform(UInt32(topicItems.count))
        
        
        topicLabel.text=topicItems[Int(randNum)].topicTitle

    }
    
  
    @IBAction func hintTapped(_ sender: Any) {
    }
    
    
    @IBAction func startTapped(_ sender: Any) {
   startButton.isHidden = true
   hintButton.isHidden = true
   nextButton.isHidden = true
        
        
        
        
   }
    
    
    
}
