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
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Model

    var countriesWithStockExchanges: [CountryWithStockExchanges] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedStockExchange: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
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

            var mutableCountryWithStockExchange = [CountryWithStockExchanges]()
            for (key, value) in dictionary {
                let countryWithStockExchanges = CountryWithStockExchanges(country: key, stockExchanges: value)
                mutableCountryWithStockExchange.append(countryWithStockExchanges)
            }
            
            mutableCountryWithStockExchange = mutableCountryWithStockExchange.sorted(by: sortStocks)
            self.countriesWithStockExchanges = mutableCountryWithStockExchange
            
            
        } catch {
            print("Error = \(error)")
        }
    }
    
    private func sortStocks(stockOne: CountryWithStockExchanges, stockTwo: CountryWithStockExchanges) -> Bool {
        return stockOne.country < stockTwo.country
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToStock" {
            let stocks4StockExchangeViewController = segue.destination as! StocksForStockExchangeViewController
            stocks4StockExchangeViewController.stockExchange = selectedStockExchange
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return countriesWithStockExchanges.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesWithStockExchanges[section].stockExchanges.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        headerView.text = countriesWithStockExchanges[section].country
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = UITableViewCell()


        tableViewCell.textLabel?.text = countriesWithStockExchanges[indexPath.section].stockExchanges[indexPath.row]

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let countryString = Array(countriesWithStockExchanges.keys)[indexPath.section]
//        let stockExchangeArray = countriesWithStockExchanges[countryString] ?? []
//        let stockExchange = stockExchangeArray[indexPath.row] ?? ""
//
//        selectedStockExchange = stockExchange
        selectedStockExchange = countriesWithStockExchanges[indexPath.section].stockExchanges[indexPath.row]
        performSegue(withIdentifier: "pushToStock", sender: self)
        
    }
}

