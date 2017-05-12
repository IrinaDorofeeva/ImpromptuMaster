//
//  TopicTableViewCell.swift
//  ImpromptuMaster
//
//  Created by Mac on 5/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class TopicTableViewCell: UITableViewCell {

    @IBOutlet var topicLabel:UILabel!
    @IBOutlet var hintLabel:UILabel!
    @IBOutlet var subjectLabel:UILabel!
    @IBOutlet var favLabel:UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
