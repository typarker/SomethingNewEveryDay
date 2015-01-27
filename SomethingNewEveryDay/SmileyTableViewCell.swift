//
//  SmileyTableViewCell.swift
//  SomethingNewEveryDay
//
//  Created by Ty Parker on 1/26/15.
//  Copyright (c) 2015 Ty Parker. All rights reserved.
//

import UIKit

class SmileyTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
