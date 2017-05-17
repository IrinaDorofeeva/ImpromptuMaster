//
//  HintPopupViewController.swift
//  ImpromptuMaster
//
//  Created by Mac on 5/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class HintPopupViewController: UIViewController {

    
    var topicPassed : Topic?
    
    @IBOutlet weak var closeButton: UIButton!
    
    
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated:true, completion: nil)
    }
    
    
    
    @IBOutlet weak var hintLabel: UILabel!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hintLabel.text=topicPassed?.topicHint
        
    }
}
