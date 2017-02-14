//
//  RequestManager.swift
//  MockAlamofire
//
//  Created by Steigerwald, Kris S. (CONT) on 2/13/17.
//  Copyright © 2017 Velaru. All rights reserved.
//

import Foundation
import Alamofire

class RequestManager {
    
    static let shared = RequestManager()
    
    let liveManager:SessionManager?
    let mockManager:SessionManager?
    
    init(_ state: RequestState = .Live) {
        
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockingURLProtocol.self]
            return configuration
        }()
        
        self.liveManager = SessionManager.default
        self.mockManager = SessionManager(configuration: configuration)
    }
    
}

let requestor = RequestManager.shared

enum RequestState {
    case Live
    case Mock
    
    var session:SessionManager {
        switch self {
        case .Live: return requestor.liveManager!
        case .Mock: return requestor.mockManager!
        }
    }
    
}
