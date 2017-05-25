//
//  ViewController.swift
//  ImpromptuMaster
//
//  Created by Mac on 5/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var topicItems : [Topic] = []

    var fetchResultController:NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load menu items from database
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
            do {
                topicItems = try managedObjectContext.fetch(fetchRequest) as! [Topic]
            } catch {
                
            }
        }
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return topicItems.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TopicTableViewCell
        
        // Configure the cell...
        cell.topicLabel.text = topicItems[indexPath.row].topicTitle
        cell.hintLabel.text = topicItems[indexPath.row].topicHint
        cell.subjectLabel.text = topicItems[indexPath.row].topicSubject
        cell.favLabel.text = topicItems[indexPath.row].topicFav
        
        return cell
    }
    

}




