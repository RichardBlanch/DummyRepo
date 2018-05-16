//
//  ViewController.swift
//  DummyRepo
//
//  Created by Richard Blanchard on 5/14/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Interface Builder

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Model

    var countriesWithStockExchanges: [String: [String]] = [:] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        makeNetworkRequest()
        title = "Stock Exchanges"
    }

    private func makeNetworkRequest() {
        let urlString = "https://api.gurufocus.com/public/user/\(API.apiKey)/exchange_list"
        guard let url = URL(string: urlString) else { return }

        let urlSession = URLSession.shared.dataTask(with: url, completionHandler: respondToData).resume()
    }

    private func respondToData(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) {
        guard let data = data else { return }

        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: [String]]
            self.countriesWithStockExchanges = dictionary
        } catch {
            print("Error = \(error)")
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return countriesWithStockExchanges.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countryString = Array(countriesWithStockExchanges.keys)[section]
        let countryCount = countriesWithStockExchanges[countryString]?.count

        return countryCount ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        headerView.text = Array(countriesWithStockExchanges.keys)[section]

        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = UITableViewCell()

        let countryString = Array(countriesWithStockExchanges.keys)[indexPath.section]
        let stockExchangeArray = countriesWithStockExchanges[countryString] ?? []
        let stockExchange = stockExchangeArray[indexPath.row] ?? ""
        tableViewCell.textLabel?.text = stockExchange

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath = \(indexPath)")
    }
}

