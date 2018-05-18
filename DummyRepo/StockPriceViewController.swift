//
//  StockPriceViewController.swift
//  DummyRepo
//
//  Created by Mac O'brien on 5/17/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import UIKit
import CoreData

class StockPriceViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    var stock: String! {
        willSet {
            stockURLString = newValue.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        }
    }
    
    var requestedStock: Stock!
    let context = CoreDataStack.shared.managedObjectContext

    
    private var stockURLString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNetworkRequest()
    }
    
    private func makeNetworkRequest() {
        let urlString = "https://api.gurufocus.com/public/user/\(API.apiKey)/stock/\(requestedStock.symbol)/keyratios"  //CHANGE ME
        guard let url = URL(string: urlString) else { return }
        
        let urlSession = URLSession.shared.dataTask(with: url, completionHandler: respondToData).resume()
    }
    
    private func respondToData(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) {
        guard let data = data else { return }
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: [String:String]]  //CHANGE ME
            
            let price = dictionary?["Price"] as? [String: String]
          let priceEntity =  PriceEntity.init(dictionary: price!, context: CoreDataStack.shared.managedObjectContext)
            
            if let stocks = fetchStocks() {
                stocks.price = priceEntity
                try? context.save()
            }
            
        } catch {
            print("Error = \(error)")
        }
        
        

    }
    
    private func fetchStocks() -> StockEntity? {
        let stockFetchRequest: NSFetchRequest<StockEntity> = StockEntity.fetchRequest()
        stockFetchRequest.predicate = NSPredicate(format: "company == %@", "\(requestedStock.company ?? "")")
        let fetchedStocks = try? context.fetch(stockFetchRequest)
        
        return fetchedStocks?.first
    }
    
}
