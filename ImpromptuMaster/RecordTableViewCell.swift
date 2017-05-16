//
//  RecordTableViewCell.swift
//  ImpromptuMaster
//
//  Created by Mac on 5/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

   
    @IBOutlet weak var recordDate: UILabel!
    @IBOutlet weak var recordTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
