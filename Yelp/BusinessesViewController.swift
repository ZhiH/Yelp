//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var searchBar: UISearchBar!
    var businesses: [Business]!
    var lastSearch: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        // initialize UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // add search bar to navigation bar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        doSearch("Restaurants", sort: .Distance, categories: [], deals: true, distance: nil)
        

        
    }

    private func doSearch(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, distance: Double?) {
        lastSearch = term
        Business.searchWithTerm(term, sort: sort, categories: categories, deals: deals) { (businesses: [Business]!, error: NSError!) -> Void in
            if distance != nil {
                func filterDist(d: Business) -> Bool {
                    var distArr = d.distance!.componentsSeparatedByString(" ")
                    var val = (distArr[0] as NSString).doubleValue
                    return distance >= val
                }
                var filteredBusinesses = businesses.filter(filterDist)
                
                self.businesses = filteredBusinesses
                self.tableView.reloadData()
            } else {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        } else {
            return 0
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }

    func filtersViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        var sort = filters["sort"] as! Int
        var categories = filters["categories"] as? [String]
        var deals = filters["categories"] as? Bool
        var distance = filters["distance"] as? Double
        println(filters)

        doSearch(lastSearch!, sort: YelpSortMode(rawValue: sort), categories: categories, deals: deals, distance: distance)
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        doSearch(searchBar.text, sort: .Distance, categories: [], deals: false, distance: nil)
    }
}
