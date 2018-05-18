//
//  StockEntityViewController.swift
//  DummyRepo
//
//  Created by Mac O'brien on 5/18/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import UIKit
import CoreData

class StockEntityViewController: UIViewController {
    let coreDataStack = CoreDataStack.shared
    let context = CoreDataStack.shared.managedObjectContext
    
    override func viewDidLoad() {
        let fetchedStocks = fetchStocks()
        
        if fetchedStocks?.isEmpty ?? false {
            print("NO STOCKS!")
        } else {
            for stock in fetchedStocks ?? [] {
                if let price = stock.price {
                    print("Beta: \(price.beta) For Stock: \(stock.company)")
                    print("")
                } else {
                    print("No price.")
                }
            }
        }
        
        makeNetworkRequest()
    }
    
    private func fetchStocks() -> [StockEntity]? {
        let stockFetchRequest: NSFetchRequest<StockEntity> = StockEntity.fetchRequest()
        let fetchedStocks = try? context.fetch(stockFetchRequest)
        
        return fetchedStocks
    }
    
    private func makeNetworkRequest() {
        let urlString = "https://api.gurufocus.com/public/user/\(API.apiKey)/exchange_stocks/NYSE"
        guard let url = URL(string: urlString) else { return }
        
        let urlSession = URLSession.shared.dataTask(with: url, completionHandler: respondToData).resume()
    }
    
    private func respondToData(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) {
        guard let data = data else { return }
        
        do {
            let dictionaryArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String: String]]
            for dict in dictionaryArray{
                let stockEntity = StockEntity.init(dict, context)
            }
            try? context.save()
            
        } catch {
            print("Error = \(error)")
        }
    }
}
