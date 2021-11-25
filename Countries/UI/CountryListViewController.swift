//
//  CountryListViewController.swift
//  Countries
//
//  Created by Syft on 03/03/2020.
//  Copyright © 2020 Syft. All rights reserved.
//

import UIKit
import CoreData
import Combine


class CountryListViewController: UIViewController {

    @IBOutlet weak var countryTableView: UITableView!
    lazy var viewModel = CountryListViewModel(withCountryManager: CountryManager())
    var subscriptions = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        countryTableView.rowHeight = UITableView.automaticDimension
        countryTableView.estimatedRowHeight = 100
        countryTableView.accessibilityIdentifier = "CountryTable"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let window = view.window else {
            return
        }
        
        viewModel.$countries.sink { [weak self] countries in
            
            guard let window = self?.view.window else {
                return
            }
        
            HUD.dismiss(from: window)
            if let countries = countries {
                self?.update(with: countries)
            }
        }
        .store(in: &subscriptions)
        
        HUD.show(in: window)
        viewModel.fetchCountryData()
    }
    
}


// MARK: - Table data source
extension CountryListViewController {
    
    enum Section: CaseIterable {
        case countries
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, Country> {
        
        return UITableViewDiffableDataSource(
            tableView: countryTableView,
            cellProvider: {  tableView, indexPath, country in
                let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell") as! CountryTableViewCell
                
                cell.country.text = country.name.common
                cell.population.text = String(country.population)
                cell.capital.text = country.capital?.first
                
                cell.accessibilityIdentifier = "\(country.name.common)-Cell"
                cell.country.accessibilityIdentifier = "Country"
                cell.capital.accessibilityIdentifier = "\(country.name.common)-Capital"
                cell.capitalLabel.accessibilityIdentifier = "\(country.name.common)-Capital-Label"
                cell.population.accessibilityIdentifier = "\(country.name.common)-Population"
                cell.populationLabel.accessibilityIdentifier = "\(country.name.common)-Population-Label"
                
                return cell
            })
    }
    
    
    func update(with options: [Country], animate: Bool = true) {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(options, toSection: .countries)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
}

