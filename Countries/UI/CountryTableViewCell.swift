//
//  CountryTableViewCell.swift
//  Countries
//
//  Created by Syft on 05/03/2020.
//  Copyright © 2020 Syft. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var capitalStackView: UIStackView!
    @IBOutlet weak var population: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    func configure(withCountry countryData: Country) {
        
        country.text = countryData.name.common
        population.text = String(countryData.population)
        capital.text = countryData.capital.first
        
        accessibilityIdentifier = "\(countryData.name.common)-Cell"
        country.accessibilityIdentifier = "Country"
        capital.accessibilityIdentifier = "\(countryData.name.common)-Capital"
        capitalLabel.accessibilityIdentifier = "\(countryData.name.common)-Capital-Label"
        population.accessibilityIdentifier = "\(countryData.name.common)-Population"
        populationLabel.accessibilityIdentifier = "\(countryData.name.common)-Population-Label"
        
    }
    
}
