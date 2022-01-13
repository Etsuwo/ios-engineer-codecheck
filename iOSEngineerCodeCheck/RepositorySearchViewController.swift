//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositorySearchViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!

    var repositories: [[String: Any]] = []

    var task: URLSessionTask?
    var searchWord: String!
    var url: String!
    var selectedIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "Detail" {
            let detailVC = segue.destination as! RepositoryDetailViewController
            detailVC.searchVC = self
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        repositories.count
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

extension RepositorySearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }

    func searchBar(_: UISearchBar, textDidChange _: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWord = searchBar.text!

        if searchWord.count != 0 {
            url = "https://api.github.com/search/repositories?q=\(searchWord!)"
            task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
                if let object = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                    if let items = object["items"] as? [[String: Any]] {
                        self.repositories = items
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            // これ呼ばなきゃリストが更新されません
            task?.resume()
        }
    }
}
