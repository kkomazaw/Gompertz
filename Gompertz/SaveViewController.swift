//
//  SaveViewController.swift
//  Gompertz
//
//  Created by Matsui Keiji on 2020/05/17.
//  Copyright © 2020 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class SaveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating  {
    
    @IBOutlet var tableView:UITableView!
    
    var savedArray = [GompertzData]()
    var unfilteredRows = [String]()
    var filteredRows = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dateFormatter = DateFormatter()
    let englishFormatter = DateFormatter()
    var t0Saved = ""
    var t1Saved = ""
    var t2Saved = ""
    var ft0Saved = ""
    var ft1Saved = ""
    var ft2Saved = ""
    var txSaved = ""
    
    override func viewDidLoad() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "search"
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: .autoupdatingCurrent)
        englishFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "en_US"))
       super.viewDidLoad()
        myCalc()
        navigationItem.rightBarButtonItem = editButtonItem
    } //override func viewDidLoad()
    
    func myCalc(){
        myCalc2()
        filteredRows = unfilteredRows
    } //func myCalc()
    
    func myCalc2(){
        unfilteredRows.removeAll()
        do{
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            let fetchRequest: NSFetchRequest<GompertzData> = GompertzData.fetchRequest()
            fetchRequest.sortDescriptors = [sortDescriptor]
            savedArray = try myContext.fetch(fetchRequest)
        }
        catch{
            print("Fetching Failed.")
        }
        if savedArray.count == 0 {
            return
        }
        for i in 0 ..< savedArray.count{
            let myDate = dateFormatter.string(from: savedArray[i].date!)
            unfilteredRows.append(myDate + " " + savedArray[i].memo!)
        }//for i in 0 ..< savedArray.count
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    } //func myCalc2()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel!.text = filteredRows[indexPath.row]
        cell.textLabel?.minimumScaleFactor = 0.5
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredRows = unfilteredRows.filter {$0.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredRows = unfilteredRows
        }
        tableView.reloadData()
    } //func updateSearchResults(for searchController: UISearchController)
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if(editing && !tableView.isEditing){
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem?.title = "done"
        }else{
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem?.title = "edit"
        }
    } //override func setEditing(_ editing: Bool, animated: Bool)
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let indexOfSelectedRow = unfilteredRows.firstIndex(of: filteredRows[indexPath.row])
            myContext.delete(savedArray[indexOfSelectedRow!])
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            unfilteredRows.remove(at: indexOfSelectedRow!)
            filteredRows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            myCalc2()
        }
    } //func tableView(_ tableView: UITableView, commit editingStyle:
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard !t0Saved.isEmpty else {return}
        let toSubView = segue.destination as! ViewController
        toSubView.t0Saved = t0Saved
        toSubView.t1Saved = t1Saved
        toSubView.t2Saved = t2Saved
        toSubView.ft0Saved = ft0Saved
        toSubView.ft1Saved = ft1Saved
        toSubView.ft2Saved = ft2Saved
        toSubView.txSaved = txSaved
        print("t0Saved: \(t0Saved)")
    } //override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexOfSelectedRow = unfilteredRows.firstIndex(of: filteredRows[indexPath.row])
        t0Saved = savedArray[indexOfSelectedRow!].t0!
        t1Saved = savedArray[indexOfSelectedRow!].t1!
        t2Saved = savedArray[indexOfSelectedRow!].t2!
        ft0Saved = savedArray[indexOfSelectedRow!].ft0!
        ft1Saved = savedArray[indexOfSelectedRow!].ft1!
        ft2Saved = savedArray[indexOfSelectedRow!].ft2!
        txSaved = savedArray[indexOfSelectedRow!].tx!
        isDatePicker = savedArray[indexOfSelectedRow!].isDatePicker
        hasTx = savedArray[indexOfSelectedRow!].hasTx
        performSegue(withIdentifier: "Unwind", sender: nil)
    } //func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    override func viewWillDisappear(_ animated: Bool) {
        t0Saved = ""
        t1Saved = ""
        t2Saved = ""
        ft0Saved = ""
        ft1Saved = ""
        ft2Saved = ""
        txSaved = ""
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
} //class SaveViewController: UIViewController
