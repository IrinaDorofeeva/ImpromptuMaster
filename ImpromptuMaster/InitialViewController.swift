//
//  InitialViewController.swift
//  ImpromptuMaster
//
//  Created by Mac on 5/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "fromInitialToSettings" {
            let destinationVC = segue.destination as! SettingsViewController
            destinationVC.fromInitialToSettings=true
        }
        
        
    }

}
