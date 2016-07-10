//
//  SearchTableViewController.swift
//  Wipic_Plain
//
//  Created by John Dorry on 6/12/16.
//  Copyright © 2016 John Dorry. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    //let searchController = UISearchController(searchResultsController: nil)
    //var filteredUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchController.searchResultsUpdater = self
        //searchController.dimsBackgroundDuringPresentation = false
        //definesPresentationContext = true
        //tableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        //filteredCandies = candies.filter { user in
        //    return candy.name.lowercaseString.containsString(searchText.lowercaseString)
        //}
        
        //tableView.reloadData()
    }
}
//extension SearchTableViewController: UISearchResultsUpdating {
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
//    }
//}
