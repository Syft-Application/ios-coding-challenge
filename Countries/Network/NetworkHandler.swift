//
//  NetworkHandler.swift
//  Countries
//
//  Created by James Weatherley on 23/11/2021.
//  Copyright © 2021 James Weatherley. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkHandlerProtocol {
    
    /// generic  method to get a parsed JSON response
    /// - Parameters:
    ///     - requestType:  Type of request (for eg: get, post etc)
    ///     - path:         A string to append the path in URL
    ///     - parameters:   Request parameters
    ///     - decodingType: The generic data model type that needs to be populated with resposne JSON
    ///     - success:      Success closure to get valid response
    ///     - failure:      Failure closure to get error details
    
    func requestData<T: Decodable>(requestType: HTTPMethod,
                                   path: String,
                                   parameters: JSON?,
                                   decodingType: T.Type,
                                   success: @escaping (_ result: T) -> (),
                                   failure: @escaping(_ error: ServerError?) -> ()
    )
}


class NetworkHandler: NetworkHandlerProtocol {
        
    func requestData<T: Decodable>(requestType: HTTPMethod,
                                   path: String,
                                   parameters: JSON? = nil,
                                   decodingType: T.Type,
                                   success: @escaping (_ result: T) -> (),
                                   failure: @escaping(_ error: ServerError?) -> ()) {
        
        Server.shared.request(requestType, path: path, parameters: parameters, decodingType: decodingType) { (response, error) in
            guard error == nil else {
                var code: String? = nil
                if let responseCode = (error as? AFError)?.responseCode {
                    code = String(responseCode)
                }
                failure(ServerError.requestError(errorDescription: "Request Error", errorCode: code, underlyingErrors: [error!]))
                return
            }
            
            if let data = response {
                success(data)
            } else {
                failure(ServerError.requestError(errorDescription: "Invalid Response", errorCode: nil, underlyingErrors: nil))
            }
        }
    }

}
