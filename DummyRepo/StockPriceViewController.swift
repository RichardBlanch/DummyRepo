//
//  StockPriceViewController.swift
//  DummyRepo
//
//  Created by Mac O'brien on 5/17/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import UIKit

class StockPriceViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    var stock: String! {
        willSet {
            stockURLString = newValue.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        }
    }
    
    var requestedStock: Stock!

    
    private var stockURLString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNetworkRequest()
    }
    
    private func makeNetworkRequest() {
        let urlString = "https://api.gurufocus.com/public/user/\(API.apiKey)/stock/\(requestedStock.symbol)AAPL/keyratios"  //CHANGE ME
        guard let url = URL(string: urlString) else { return }
        
        let urlSession = URLSession.shared.dataTask(with: url, completionHandler: respondToData).resume()
    }
    
    private func respondToData(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) {
        guard let data = data else { return }
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: [String:String]]  //CHANGE ME
            
            let price = dictionary?["Price"] as? [String: String]
            let daysHigh = price!["Day's High"] as? String
            
            DispatchQueue.main.async {
                self.priceLabel.text = daysHigh
            }
        } catch {
            print("Error = \(error)")
        }
        
        

    }
}
