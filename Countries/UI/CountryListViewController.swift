//
//  CountryListViewController.swift
//  Countries
//
//  Created by Syft on 03/03/2020.
//  Copyright © 2020 Syft. All rights reserved.
//

import UIKit
import CoreData


class CountryListViewController: UIViewController {

    @IBOutlet weak var countryTableView: UITableView!
    lazy var viewModel = CountryListViewModel(withCountryManager: CountryManager())

    
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
        
        HUD.show(in: window)
        viewModel.fetchCountryData()
    }
    
}

