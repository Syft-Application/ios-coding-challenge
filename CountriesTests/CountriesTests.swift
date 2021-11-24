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


class MockNetworkManager: NetworkHandlerProtocol {
    
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


class MockCountryListViewModel: CountryListViewModelProtocol {
    
    var countries: [Country]?
    func fetchCountryData(usingCountryManager countryManager: CountryManager) {
        
        countryManager.getAllCountries { countries in
            self.countries = countries
        } failure: { error in
            assertionFailure("Failed to get countries")
        }
    }
    
}


class CountriesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchCountries() {
        
        let viewModel = MockCountryListViewModel()
        viewModel.fetchCountryData(usingCountryManager: CountryManager(networkHandler: MockNetworkManager()))
        
        let uk = viewModel.countries?
            .filter({$0.name.common == "United Kingdom"})
            .first
        XCTAssertNotNil(uk)
        
        XCTAssertEqual(uk!.name.official, "United Kingdom of Great Britain and Northern Ireland")
    }
}
