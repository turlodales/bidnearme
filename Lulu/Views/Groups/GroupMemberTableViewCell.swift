//
//  GroupMemberTableViewCell.swift
//  Lulu
//
//  Created by Patrick Czeczko on 2016-12-06.
//  Copyright © 2016 Team Lulu. All rights reserved.
//

import UIKit
import M13Checkbox

class GroupMemberTableViewCell: UITableViewCell {
    @IBOutlet weak var memberStateCheckBox: M13Checkbox!
    @IBOutlet weak var memberName: UILabel!
    
    var user: User!
}
