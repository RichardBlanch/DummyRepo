//
//  PriceEntity+Extension.swift
//  DummyRepo
//
//  Created by Mac O'brien on 5/18/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import Foundation
import CoreData

extension PriceEntity {
    convenience init(dictionary: [String: String], context: NSManagedObjectContext) {
        self.init(context: context)
        self.beta = dictionary["Beta"] ?? ""
        self.float = dictionary["Float"] ?? ""
        self.daysHigh = dictionary["Day's High"] ?? ""
        self.daysLow = dictionary["Day's Low"] ?? ""
        self.daysOpen = dictionary["Day's Open"] ?? ""
    }
}
