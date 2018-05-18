//
//  CustomClass.swift
//  DummyRepo
//
//  Created by Mac O'brien on 5/17/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import Foundation

struct CountryWithStockExchanges {
    
    let country: String
    let stockExchanges: [String]
    
    var count: Int {
        return stockExchanges.count
    }
    
    init(country: String, stockExchanges: [String]) {
        self.country = country
        self.stockExchanges = stockExchanges
    }
    

}
