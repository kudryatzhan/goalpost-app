//
//  GoalsVC.swift
//  goalpost-app
//
//  Created by Kudryatzhan Arziyev on 11/18/17.
//  Copyright © 2017 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.fetch { (complete) in
            if complete {
                if !goals.isEmpty {
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func addGoalBtnWasPressed(_ sender: UIButton) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else { return }
        
        presentDetail(createGoalVC)
    }
}

extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalTableViewCell") as? GoalTableViewCell else { return UITableViewCell() }
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        
        return cell
    }
}

extension GoalsVC {
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest: NSFetchRequest<Goal> = NSFetchRequest(entityName: "Goal")
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            print("Successfully fetched data")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
}
