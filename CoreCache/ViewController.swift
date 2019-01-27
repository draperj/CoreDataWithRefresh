//
//  ViewController.swift
//  CoreCache
//
//  Created by Josh Draper on 1/27/19.
//  Copyright © 2019 JDraper. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear

        let task = tasks[indexPath.row]
        
        if let myName = task.name, let label = cell.textLabel {
            label.text = myName
            label.textColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let context = context else {
                return
            }
            let task = tasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                tasks = try context.fetch(Task.fetchRequest())
            } catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        
        return refreshControl
    }()
    
    var context: NSManagedObjectContext!
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(self.refreshControl)
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        context = delegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    func getData() {
        do {
            guard let context = context else {
                return
                
            }
            
            tasks = try context.fetch(Task.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getData()
      
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}
