//
//  SavedRecViewController.swift
//  ImpromptuMaster
//
//  Created by Mac on 5/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class SavedRecViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var savedRecTable: UITableView!
    var recordItems : [Record] = []
    var fetchResultController:NSFetchedResultsController<NSFetchRequestResult>!
    var audioPlayer : AVAudioPlayer?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
            do {
                recordItems = try managedObjectContext.fetch(fetchRequest) as! [Record]
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        print("#########")
        print(recordItems)
        print("#########")
        
            }
    
    
 

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recordItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordTableViewCell
        let recordItem = recordItems[indexPath.row]
        cell.recordTitle.text = recordItem.title
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        let recordItem = recordItems[indexPath.row]
        
        
        /*
         
         performSegue(withIdentifier: "startRecording", sender: self)
         
         }
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destinationVC = segue.destination as! RecordViewController
         destinationVC.topicPassed=shownTopic
         }

         
         */
        
        tableView.deselectRow(at: indexPath, animated: true)
        

        }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            
            let recordItem = self.recordItems[indexPath.row]
            
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                
                managedObjectContext.delete(recordItem)
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
                do {
                    self.recordItems = try managedObjectContext.fetch(fetchRequest) as! [Record]
                } catch {
                    print("Failed to retrieve record")
                    print(error)
                }
                tableView.reloadData()
            }
            
        }
        delete.backgroundColor = hexStringToUIColor(hex: "#f05f59")
        return [delete]
    }

    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    

   

}
