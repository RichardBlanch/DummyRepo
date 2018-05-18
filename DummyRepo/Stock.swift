//
//  Stock.swift
//  DummyRepo
//
//  Created by Mac O'brien on 5/17/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import Foundation
import CoreData

struct Stock {

    let symbol: String
    let exchange: String
    let company: String
    let currency: String
    let industry: String
    let sector: String
    let subindustry: String
    
    init(dictionary: [String: String]) {
        self.symbol = dictionary["symbol"] ?? ""
        self.exchange = dictionary["exchange"] ?? ""
        self.company = dictionary["company"] ?? ""
        self.currency = dictionary["currency"] ?? ""
        self.industry = dictionary["industry"] ?? ""
        self.sector = dictionary["sector"] ?? ""
        self.subindustry = dictionary["subindustry"] ?? ""
    }
}

extension StockEntity {
    convenience init(_ dictionary: [String: String], _ context: NSManagedObjectContext) {
        self.init(context: context)

        self.symbol = dictionary["symbol"] ?? ""
        self.exchange = dictionary["exchange"] ?? ""
        self.company = dictionary["company"] ?? ""
        self.currency = dictionary["currency"] ?? ""
        self.industry = dictionary["industry"] ?? ""
        self.sector = dictionary["sector"] ?? ""
        self.subindustry = dictionary["subindustry"] ?? ""
    }
}
