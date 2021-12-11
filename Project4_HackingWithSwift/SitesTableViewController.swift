//
//  SitesTableViewController.swift
//  Project4_HackingWithSwift
//
//  Created by Николай Никитин on 11.12.2021.
//

import UIKit

class SitesTableViewController: UITableViewController {
  var websites = ["apple.com", "hackingwithswift.com", "google.com", "yandex.ru"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      cell.textLabel?.text = websites[indexPath.row]
        return cell
    }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let viewController = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController else { return }
    viewController.websites = websites
    viewController.choosenWebsite = indexPath.row
    navigationController?.pushViewController(viewController, animated: true)
  }

}
