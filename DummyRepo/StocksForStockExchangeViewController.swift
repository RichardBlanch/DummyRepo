//
//  StocksForStockExchangeViewController.swift
//  DummyRepo
//
//  Created by Richard Blanchard on 5/16/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import UIKit

class StocksForStockExchangeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var stockExchange: String!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    
  var selectedStock: Stock!

    var stockExchangesWithStocks: StockExchangeWithStocks? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "statsForStock" {
            let statsForStock = segue.destination as! StockPriceViewController
            statsForStock.requestedStock = selectedStock
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNetworkRequest()
    }
    
    private func makeNetworkRequest() {
        let urlString = "https://api.gurufocus.com/public/user/\(API.apiKey)/exchange_stocks/\(stockExchange ?? "")"
        guard let url = URL(string: urlString) else { return }
        
        let urlSession = URLSession.shared.dataTask(with: url, completionHandler: respondToData).resume()           
    }
    
    private func respondToData(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) {
        guard let data = data else { return }
        
        do {
            let dictionaryArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String: String]]

            var mutableStocks = [Stock]()

            for dictionary in dictionaryArray {
                let stock = Stock(dictionary: dictionary)
                mutableStocks.append(stock)
            }
            
            mutableStocks = mutableStocks.sorted(by: { $0.company < $1.company })
    
            self.stockExchangesWithStocks = StockExchangeWithStocks(stockExchange: stockExchange, stocks: mutableStocks)
            
            
        } catch {
            print("Error = \(error)")
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockExchangesWithStocks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //let stockDictionary = dataDictionary[indexPath.row]
      //  let stock = stockDictionary["company"]
        cell.textLabel?.text = stockExchangesWithStocks?.stocks[indexPath.row].company
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let countryString = Array(countriesWithStockExchanges.keys)[indexPath.section]
        //        let stockExchangeArray = countriesWithStockExchanges[countryString] ?? []
        //        let stockExchange = stockExchangeArray[indexPath.row] ?? ""
        //
        //        selectedStockExchange = stockExchange
        selectedStock = stockExchangesWithStocks?.stocks[indexPath.row]
        performSegue(withIdentifier: "statsForStock", sender: self)
        
    }
    

}

