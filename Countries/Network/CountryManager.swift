//
//  CountryManager.swift
//  Countries
//
//  Created by James Weatherley on 23/11/2021.
//  Copyright © 2021 James Weatherley. All rights reserved.
//

import Foundation

protocol CountryManagerProtocol {
    
    /// Method to get the login type
    /// - Parameters:
    ///     - success:    Completion handler with success response
    ///     - failure:    Completion handler with failure response
    func getAllCountries(
        success: @escaping ([Country]) -> (),
        failure: @escaping(ServerError?) -> ()
    )
    
}


struct CountryManager: CountryManagerProtocol {
    
    // Network handler to perform all API calls
    private let networkHandler: NetworkHandlerProtocol
    
    init(networkHandler: NetworkHandlerProtocol = NetworkHandler()) {
        self.networkHandler = networkHandler
    }
    
    func getAllCountries(success: @escaping ([Country]) -> (), failure: @escaping (ServerError?) -> ()) {
        
        let path = APIEndpoint.allCountries.rawValue
        
        networkHandler.requestData(requestType: .get,
                                   path: path,
                                   parameters: nil,
                                   decodingType: [Country].self) { result in
            success(result)
        } failure: { error in
            failure(error)
        }

    }
    
}
