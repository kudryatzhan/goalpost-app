//
//  GoalTableViewCell.swift
//  goalpost-app
//
//  Created by Kudryatzhan Arziyev on 11/18/17.
//  Copyright © 2017 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {

    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var goalTypeLabel: UILabel!
    @IBOutlet weak var goalProgressLabel: UILabel!
    
    func configureCell(goal: Goal)  {
        self.goalDescriptionLabel.text = goal.goalDescription
        self.goalTypeLabel.text = goal.goalType
        self.goalProgressLabel.text = String(goal.goalProgress)
    }
}
