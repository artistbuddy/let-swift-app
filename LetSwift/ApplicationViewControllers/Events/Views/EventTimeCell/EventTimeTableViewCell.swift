//
//  EventTimeTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 26.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventTimeTableViewCell: AppTableViewCell {
    
    @IBOutlet private weak var dateLabel: AppLabel!
    @IBOutlet private weak var timeLabel: AppLabel!
    
    @IBOutlet private weak var separatorConstraint: NSLayoutConstraint!
    
    var date: String? {
        get {
            return dateLabel.text
        }
        set {
            dateLabel.text = newValue
        }
    }
    
    var time: String? {
        get {
            return timeLabel.text
        }
        set {
            timeLabel.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorConstraint.constant = 1.0 / UIScreen.main.scale
    }
}
