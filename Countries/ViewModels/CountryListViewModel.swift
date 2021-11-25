//
//  CountryListViewModel.swift
//  Countries
//
//  Created by James Weatherley on 23/11/2021.
//  Copyright © 2021 James Weatherley. All rights reserved.
//

import Foundation
import Combine


class CountryListViewModel: ObservableObject {
        
    let countryManager: CountryManagerProtocol
    @Published var countries: [Country]?

    
    required init(withCountryManager countryManager: CountryManagerProtocol) {
        self.countryManager = countryManager
    }
    
    
    func fetchCountryData() {
        countryManager.getAllCountries { countries in
            self.countries = countries.sorted(by: {$0.name.common.localizedCompare($1.name.common) == .orderedAscending})
        } failure: { error in
            assertionFailure("There was an error: \(error!)")
        }
    }
    
}
