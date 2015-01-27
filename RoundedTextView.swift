//
//  RoundedTextView.swift
//  SomethingNewEveryDay
//
//  Created by Ty Parker on 1/27/15.
//  Copyright (c) 2015 Ty Parker. All rights reserved.
//

import UIKit

class RoundedTextView: UITextView {
    
    

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    
    layer.cornerRadius = 5
    layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
    layer.borderWidth = 0.5
    clipsToBounds = true
        // Drawing code
    }
    

}
