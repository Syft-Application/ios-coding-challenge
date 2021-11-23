//
//  Server.swift
//  CodeTest
//
//  Created by Syft on 03/03/2020.
//  Copyright © 2020 Syft. All rights reserved.
//

import Alamofire
import Foundation
import CoreData


// Create an account at https://rapidapi.com/developer/dashboard and add a new app to get an API key.
// https://docs.rapidapi.com/docs/keys

let kRapidAPIKey = "SIGN-UP-FOR-KEY"


public typealias JSON = [String : Any]

public extension Notification.Name {
    static let ServerReachabilityDidChange = Notification.Name("ServerReachabilityDidChange")
}


class Server {

    public static let shared = Server()
    
    var host: String
    private let path: String
    private let networkReachabilityManager: NetworkReachabilityManager?
    
    
    lazy var session: Session = {
        return Session.default
    }()
    
    
    
    init(host: String, path: String) {
                
        self.host = host
        self.path = path
        
        networkReachabilityManager = NetworkReachabilityManager(host: host)
        networkReachabilityManager?.startListening(onUpdatePerforming: { (status) in
            NotificationCenter.default.post(name: .ServerReachabilityDidChange, object: nil)
        })
    }
    
    private convenience init() {
        self.init(host: "restcountries-v1.p.rapidapi.com", path: "/")
    }

    
    /// Create URL to call given call path
    ///
    /// - Parameters:
    ///     - path: *path* to call
    ///
    /// - returns: URL
    public func url( for path: String ) -> String {
        return "https://\(host)\(self.path)\(path)"
    }
    
    
    /// Create list of headers to send to server
    ///
    /// - returns: list of headers
    public func headers( extraHeaders: HTTPHeaders? = nil ) -> HTTPHeaders {
        
        var headers: HTTPHeaders = [
            "X-RapidAPI-Host": "restcountries-v1.p.rapidapi.com",
            "X-RapidAPI-Key": kRapidAPIKey
        ]
        
        if let extraHeaders = extraHeaders {
            extraHeaders.forEach {headers.add($0)}
        }
        
        return headers
    }
    
    
    /// Perform request to server.
    ///
    /// - Parameters:
    ///     - method:             *http method type get, post, patch etc.
    ///     - path:               *path* for the operation.
    ///     - parameters:         The *parameters* to be send to server as JSON.
    ///     - extraHeaders:       The *HTTPHeaders* to be send to server as JSON.
    ///     - decodingType:       The data model type to be parsed
    ///     - completionHandler:  A *closure* to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func request<T: Decodable>( _ method: HTTPMethod, path: String, parameters: [String : Any]? = nil, extraHeaders: HTTPHeaders? = nil, decodingType: T.Type, completionHandler: @escaping ( _ response: T?, _ error: Error? ) -> Void ) -> DataRequest {
        return request(method, path: path, parameters: parameters, extraHeaders: extraHeaders, decodingType: decodingType, completionHandler: { (response: Any?, header, error) in
            completionHandler( response as? T,  error)
        })
    }
    
}



extension Server {
    
    @discardableResult
    func request<T: Decodable>( _ method: HTTPMethod, path: String, parameters: [String : Any]? = nil, extraHeaders: HTTPHeaders? = nil,  decodingType: T.Type, completionHandler: @escaping ( _ response: Any?, _ headers: [AnyHashable : Any]?, _ error: Error? ) -> Void ) -> DataRequest {
        
        assert(parameters == nil || JSONSerialization.isValidJSONObject(parameters!), "parameters must be valid JSON")
        
        return session.request(url(for: path),
                               method: method,
                               parameters: parameters,
                               encoding: method == .get ? URLEncoding() : JSONEncoding(),
                               headers: self.headers(extraHeaders: extraHeaders)
        )
            .validate(statusCode: method == .post ? [200, 201] : [200])
            .responseDecodable(of: decodingType) { response in
                
                var allHeaderFields = [AnyHashable : Any]()
                if let headerFields = response.response?.allHeaderFields {
                    allHeaderFields = self.populateHeaderFields(headerFields: headerFields)
                }
                
                switch response.result {
                case .success(let value):
                    completionHandler(value, allHeaderFields, nil)
                case .failure(let htmlError):
                    let result = self.data2JSON(data: response.data, error: htmlError)
                    switch result {
                    case .success(_):
                        assertionFailure()
                    case .failure(let serverError):
                        completionHandler(nil, allHeaderFields, serverError)
                    }
                }
            }
    }
    
    // Looks like with Alamofire we want the method above to return a DecodableResponseSerializer,
    // and have JSON as a Decodable struct rather than a typealias to [String : Any].
    // For now, just get something to work.
    func data2JSON(data: Data?, error: Error?) -> Result<Any?, Error> {
        
        var jsonResponse: Any?
        
        // if we have data try to deserialize it
        if let data = data, !data.isEmpty {
            
            #if DEBUG
            print("### JSON response size: \(data.count)")
            #endif
            
            do {
                jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch let serializationError {
                // use deserialization error if we have no network error
                if error == nil {
                    return .failure(serializationError)
                }
            }
        }
        
        if let error = error {
            // if there was server error use it
            if let jsonResponse = jsonResponse as? JSON, let errorCode = jsonResponse["error"] as? String {
                                
                switch errorCode {
                default:
                    let errorDescription = jsonResponse["error_description"] as? String ?? "Server Error"
                    return .failure(ServerError.requestError(errorDescription: errorDescription, errorCode: errorCode, underlyingErrors: [error]))
                }
            }
            
            // Otherwise use server error
            else {
                return .failure(error)
            }
        }
        
        return .success(jsonResponse)
    }
    
    
    private func populateHeaderFields(headerFields: [AnyHashable : Any]) -> [AnyHashable : Any] {
        var allHeaderFields = [AnyHashable : Any]()
        for (key, value) in headerFields {
            if let key = key as? String {
                allHeaderFields[key.lowercased()] = value
            } else {
                allHeaderFields[key] = value
            }
        }
        return allHeaderFields
    }

}
