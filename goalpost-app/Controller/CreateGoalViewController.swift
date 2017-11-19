//
//  CreateGoalViewController.swift
//  goalpost-app
//
//  Created by Kudryatzhan Arziyev on 11/19/17.
//  Copyright © 2017 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit

class CreateGoalViewController: UIViewController {
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var shortTermButton: UIButton!
    @IBOutlet weak var longTermButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var goalType: GoalType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.bindToKeyboard()
        shortTermButton.setSelectedColor()
        longTermButton.setDeselectedColor()
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func shotTermButtonPressed(_ sender: UIButton) {
        goalType = .shortTerm
        shortTermButton.setSelectedColor()
        longTermButton.setDeselectedColor()
    }
    
    @IBAction func longTermButtonPressed(_ sender: UIButton) {
        goalType = .longTerm
        longTermButton.setSelectedColor()
        shortTermButton.setDeselectedColor()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismissDetail()
    }
}
