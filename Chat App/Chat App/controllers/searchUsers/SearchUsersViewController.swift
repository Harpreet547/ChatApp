//
//  SearchUsersViewController.swift
//  Chat App
//
//  Created by Zensar on 22/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit

class SearchUsersViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!

    //MARK: Variables
    var viewModel = SearchBarViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    var searchText: String?
    var delegate: SearchResultDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Users"
        initSearchBar()
        tableView.tableFooterView = viewModel.returnEmptyView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: User defined methods
    func initSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
}

extension SearchUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let _ = self.navigationController?.popViewController(animated: true)
        delegate?.searchResult(user: viewModel.filteredUsers[indexPath.row])
        
    }
}

extension SearchUsersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchBarUserCell") as! SearchBarUserTableViewCell
        cell.label.text = viewModel.filteredUsers[indexPath.row].email
        
        return cell
    }
}

extension SearchUsersViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}

extension SearchUsersViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    //User defined methods
    func filterContentForSearchText(searchText: String) {
        viewModel.searchUserOnServerUsing(searchText: searchText) { 
            self.searchText = searchText
            self.tableView.reloadData()
        }
        
    }
}
