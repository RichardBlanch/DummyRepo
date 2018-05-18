//
//  StockExchangeWithStocks.swift
//  DummyRepo
//
//  Created by Mac O'brien on 5/17/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import Foundation

struct StockExchangeWithStocks{
    let stockExchange: String
    let stocks: [Stock]
    
    var count: Int {
        return stocks.count
    }
    
    init (stockExchange: String, stocks:[Stock]){
        self.stockExchange = stockExchange
        self.stocks = stocks
    }
}
