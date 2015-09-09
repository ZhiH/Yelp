//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Zhi Huang on 9/8/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?

    let data = [("Deal", ["Offering a Deal"]),
        ("Distance", ["0.3 miles", "1 mile", "5 miles", "20 miles"]),
        ("Sort By", ["Best Match", "Distance", "Highest Rated"]),
        ("Category", ["Italian", "Japanese", "Korean"])]
    let sectionFilterMapping = [
        0: "deals",
        1: "distance",
        2: "sort",
        3: "categories"]
    let distanceFilterMapping = [
        0: 0.3,
        1: 1.0,
        2: 5.0,
        3: 20.0]
    let categoryCodeMapping = [
        0: "italian",
        1: "japanese",
        2: "korean"]
    
    var filterStates = [String: Bool]()


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

        var filters = [String : AnyObject]()
        var deals: Bool?
        var distance: Double?
        var sort: Int?
        var categories = [String]()
        for (secRow, isSelected) in filterStates {
            if isSelected {
                let secRowArr = secRow.componentsSeparatedByString("-")
                let section = secRowArr[0].toInt()
                if section == 0 {
                    deals = true
                } else if section == 1 {
                    distance = distanceFilterMapping[secRowArr[1].toInt()!]
                } else if section == 2 {
                    sort = secRowArr[1].toInt()
                } else if section == 3 {
                    categories.append(categoryCodeMapping[secRowArr[1].toInt()!]!)
                }
            }
        }
        if deals == true {
            filters["deals"] = true
        } else {
            filters["deals"] = false
        }
        if distance != nil {
            filters["distance"] = distance
        }
        if sort != nil {
            filters["sort"] = sort
        } else {
            filters["sort"] = 1
        }
        if categories.count > 0 {
            filters["categories"] = categories
        }
        delegate?.filtersViewController!(self, didUpdateFilters: filters)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].1.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        let filterSection = data[indexPath.section].1
        cell.switchLabel?.text = filterSection[indexPath.row]
        
        cell.delegate = self
        
        cell.onSwitch.on = filterStates["\(indexPath.section)-\(indexPath.row)"] ?? false
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].0
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        // Yea it's brute forced below, but given the time constraint and stuff, best I could do for now :/
        let indexPath = tableView.indexPathForCell(switchCell)!
        if indexPath.section == 2 {
            filterStates["2-0"] = false
            filterStates["2-1"] = false
            filterStates["2-2"] = false
        } else if indexPath.section == 1 {
            filterStates["1-0"] = false
            filterStates["1-1"] = false
            filterStates["1-2"] = false
            filterStates["1-3"] = false
        }
        filterStates["\(indexPath.section)-\(indexPath.row)"] = value
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
