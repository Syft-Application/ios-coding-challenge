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
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var area: UILabel!
    
    
    func configure(withCountry countryData: Country) {
        
        country.text = countryData.name.common
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedPopulation = formatter.string(from: NSNumber(value: countryData.population))
        population.text = formattedPopulation
        
        if let capital = countryData.capital?.first {
            self.capital.text = capital
        } else {
            capital.isHidden = true
            capitalLabel.isHidden = true
        }
        
        region.text = countryData.region
        area.text = formatter.string(from: NSNumber(value: countryData.area))
        
        accessibilityIdentifier = "\(countryData.name.common)-Cell"
        country.accessibilityIdentifier = "Country"
        capital.accessibilityIdentifier = "\(countryData.name.common)-Capital"
        capitalLabel.accessibilityIdentifier = "\(countryData.name.common)-Capital-Label"
        population.accessibilityIdentifier = "\(countryData.name.common)-Population"
        populationLabel.accessibilityIdentifier = "\(countryData.name.common)-Population-Label"
    }

}
