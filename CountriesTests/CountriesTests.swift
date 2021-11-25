//
//  CountriesTests.swift
//  CountriesTests
//
//  Created by Syft on 03/03/2020.
//  Copyright © 2020 Syft. All rights reserved.
//

import XCTest
import Alamofire
@testable import Countries


class MockNetworkHandler: NetworkHandlerProtocol {
    
    func requestData<T>(requestType: HTTPMethod,
                        path: String,
                        parameters: JSON?,
                        decodingType: T.Type,
                        success: @escaping (T) -> (),
                        failure: @escaping (ServerError?) -> ()) where T : Decodable {
        
        var countries: T
        if let json = Bundle.main.url(forResource: "MockCountries", withExtension: "json") {
            let decoder = JSONDecoder()
            countries = try! decoder.decode(T.self, from: Data(contentsOf: json))
            success(countries)
        } else {
            failure(ServerError.invalidFieldsError(errorDescription: "Failed to get countries", fields: nil, nested: nil))
        }
    }
    
}


class CountriesTests: XCTestCase {

    let viewModel = CountryListViewModel(withCountryManager: CountryManager(networkHandler: MockNetworkHandler()))

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel.fetchCountryData()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchCountries() {
        
        let uk = viewModel.countries?
            .filter({$0.name.common == "United Kingdom"})
            .first
        XCTAssertNotNil(uk)
        
        XCTAssertEqual(uk!.name.official, "United Kingdom of Great Britain and Northern Ireland")
    }
    
    func testOrder() {
        
        // The purpose of this test is to check the countries are displayed in alphabetical order.
        // The test checks that the first two and last two are as expected.
        // A UK locale is assumed.
        let exampleCountries = ["Afghanistan", "Åland Islands", "Zambia", "Zimbabwe"]
        var firstAndLastCountries = viewModel.countries!.compactMap {$0.name.common}
        firstAndLastCountries.removeSubrange(2..<(firstAndLastCountries.count - 2))
        XCTAssertEqual(exampleCountries, firstAndLastCountries)
    }
    
    func testPopulation() {
        
        // Check the populations of Afghanistan, China and Antarctica are as expected.
        let testCountries = ["Antarctica", "Afghanistan", "China"]
        let expectedPopulations = [1000, 2837743, 1402112000]
        
        let populations = viewModel.countries!
            .filter {testCountries.contains($0.name.common)}
            .map {$0.population}
            .sorted()
        
        XCTAssertEqual(expectedPopulations, populations)
    }
    
}
