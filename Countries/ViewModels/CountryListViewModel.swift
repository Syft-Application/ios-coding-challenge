//
//  CountryListViewModel.swift
//  Countries
//
//  Created by James Weatherley on 23/11/2021.
//  Copyright © 2021 James Weatherley. All rights reserved.
//

import Foundation


class CountryListViewModel: ObservableObject {
        
    let countryManager: CountryManagerProtocol
    var countries: [Country]?

    
    required init(withCountryManager countryManager: CountryManagerProtocol) {
        self.countryManager = countryManager
    }
    
    
    func fetchCountryData() {
        countryManager.getAllCountries { countries in
            self.countries = countries
        } failure: { error in
            assertionFailure("There was an error: \(error!)")
        }
    }
    
}
