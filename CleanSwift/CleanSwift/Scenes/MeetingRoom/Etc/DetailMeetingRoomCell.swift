//
//  DetailMeetingRoomCell.swift
//  CleanSwift_test
//
//  Created by Jang Dong Min on 2019/12/24.
//  Copyright © 2019 Paul Jang. All rights reserved.
//

import Foundation
import UIKit

class DetailMeetingRoomCell: UITableViewCell {
    @IBOutlet weak var meetingRoomNameLabel: UILabel!
    @IBOutlet weak var meetingRoomPosLabel: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabelLeftMargin: NSLayoutConstraint!
     
    @IBOutlet weak var stickLeftMargin: NSLayoutConstraint!
    
    @IBOutlet weak var time_9_block: UIView!
    @IBOutlet weak var time_9_30_block: UIView!
    
    @IBOutlet weak var time_10_block: UIView!
    @IBOutlet weak var time_10_30_block: UIView!
    
    @IBOutlet weak var time_11_block: UIView!
    @IBOutlet weak var time_11_30_block: UIView!
    
    @IBOutlet weak var time_12_block: UIView!
    @IBOutlet weak var time_12_30_block: UIView!
    
    @IBOutlet weak var time_13_block: UIView!
    @IBOutlet weak var time_13_30_block: UIView!
    
    @IBOutlet weak var time_14_block: UIView!
    @IBOutlet weak var time_14_30_block: UIView!
    
    @IBOutlet weak var time_15_block: UIView!
    @IBOutlet weak var time_15_30_block: UIView!
    
    @IBOutlet weak var time_16_block: UIView!
    @IBOutlet weak var time_16_30_block: UIView!
    
    @IBOutlet weak var time_17_block: UIView!
    @IBOutlet weak var time_17_30_block: UIView!
     
    var timeBlocks = [String:UIView]()
    
    func addTimeBlocks() {
        timeBlocks.removeAll()
        
        timeBlocks["0900"] = time_9_block
        timeBlocks["0930"] = time_9_30_block
        
        timeBlocks["1000"] = time_10_block
        timeBlocks["1030"] = time_10_30_block
        
        timeBlocks["1100"] = time_11_block
        timeBlocks["1130"] = time_11_30_block
        
        timeBlocks["1200"] = time_12_block
        timeBlocks["1230"] = time_12_30_block
        
        timeBlocks["1300"] = time_13_block
        timeBlocks["1330"] = time_13_30_block
        
        timeBlocks["1400"] = time_14_block
        timeBlocks["1430"] = time_14_30_block
        
        timeBlocks["1500"] = time_15_block
        timeBlocks["1530"] = time_15_30_block
        
        timeBlocks["1600"] = time_16_block
        timeBlocks["1630"] = time_16_30_block
        
        timeBlocks["1700"] = time_17_block
        timeBlocks["1730"] = time_17_30_block
    }
}


