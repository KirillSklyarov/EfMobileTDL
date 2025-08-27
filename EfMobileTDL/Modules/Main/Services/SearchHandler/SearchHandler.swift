//
//  SearchHandler.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 26.08.2025.
//

import UIKit

protocol SearchHandling {
    func bind(to searchController: UISearchController)
    func reset(_ searchController: UISearchController)
}

final class SearchHandler: NSObject, SearchHandling {

    private let output: MainViewOutput

    init(output: MainViewOutput) {
        self.output = output
    }

    func bind(to searchController: UISearchController) {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.delegate = self
    }

    func reset(_ searchController: UISearchController) {
        searchController.searchBar.text = ""
    }
}

extension SearchHandler: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            Log.main.errorAlways("Search text is empty")
            return
        }
        output.eventHandler(.filterData(by: searchText))
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        output.eventHandler(.cancelSearch)
    }
}
