//
//  Country.swift
//  Countries
//
//  Created by Syft on 04/03/2020.
//  Copyright © 2020 Syft. All rights reserved.
//

import Foundation
import CoreData


struct Country: Codable, Hashable {
    
    var capital: [String]
    var name: CountryName
    var population: Int
}


struct CountryName: Codable, Hashable {
    var common: String
    var official: String
}
