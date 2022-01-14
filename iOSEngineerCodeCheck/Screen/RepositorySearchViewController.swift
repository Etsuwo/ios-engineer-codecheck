//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositorySearchViewController: UITableViewController {
    // MARK: IBOutlet

    @IBOutlet private weak var searchBar: UISearchBar!

    // MARK: Propaties

    private var repositories: [[String: Any]] = []
    private var task: URLSessionTask?
    private var selectedIndex: Int?

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: Private Methods

    private func setupUI() {
        searchBar.text = L10n.RepositorySearch.SearchBar.text
        searchBar.delegate = self
    }

    private func searchRepository(with word: String) {
        let url = "https://api.github.com/search/repositories?q=\(word)"
        task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
            if let object = try! JSONSerialization.jsonObject(with: data!) as? [String: Any],
               let items = object["items"] as? [[String: Any]]
            {
                self.repositories = items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task?.resume()
    }

    // MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "Detail" {
            let detailVC = segue.destination as! RepositoryDetailViewController
            guard let selectedIndex = selectedIndex else { return }
            detailVC.repository = repositories[selectedIndex]
        }
    }

    // MARK: TableView Methods

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        repositories.count
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? L10n.Common.blank
        cell.detailTextLabel?.text = repository["language"] as? String ?? L10n.Common.blank
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

// MARK: UISearchBarDelegate

extension RepositorySearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = L10n.Common.blank
        return true
    }

    func searchBar(_: UISearchBar, textDidChange _: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchWord = searchBar.text!
        if searchWord.isNotEmpty {
            searchRepository(with: searchWord)
        }
    }
}