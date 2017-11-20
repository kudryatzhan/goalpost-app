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
    @IBOutlet weak var goalRemovedView: UIView!
    
    var goals: [Goal] = []
    
    var removedGoal: Goal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCoreDataObjects()
        
        tableView.reloadData()
    }
    
    func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
                if !goals.isEmpty {
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }
    
    @IBAction func addGoalBtnWasPressed(_ sender: UIButton) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else { return }
        
        presentDetail(createGoalVC)
    }
    
    @IBAction func undoGoalRemoveTapped(_ sender: UIButton) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: managedContext)
        
        print(removedGoal)
        goal.goalDescription = removedGoal?.description
        goal.goalType = removedGoal?.goalType
        goal.goalCompletionValue = removedGoal!.goalCompletionValue
        goal.goalProgress = removedGoal!.goalProgress
        
        do {
            try managedContext.save()
            print("Successfully saved data")
        } catch {
            debugPrint("Could not saved: \(error)")
        }
        
        fetchCoreDataObjects()
        
        tableView.reloadData()
        
        goalRemovedView.isHidden = true
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.set(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 1)
        
        return [deleteAction, addAction]
    }
}

extension GoalsVC {
    
    func set(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress += 1
        } else {
            return
        }
        do {
            try managedContext.save()
            print("Successfully set progress!")
        } catch {
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
    }
    
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        removedGoal = goals[indexPath.row]
        managedContext.delete(goals[indexPath.row])
        
        do {
            try managedContext.save()
        
            goalRemovedView.isHidden = false
            
            print("Successfully removed goal")
        } catch {
            debugPrint("Could not remove: \(error)")
        }
    }
    
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
