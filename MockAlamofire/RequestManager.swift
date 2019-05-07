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
    fileprivate let liveManager: SessionManager
    fileprivate let mockManager: SessionManager
    
    init(_ state: RequestState = .live) {
        
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockingURLProtocol.self]
            return configuration
        }()
        
        self.liveManager = SessionManager.default
        self.mockManager = SessionManager(configuration: configuration)
    }
}

enum RequestState {
    case live
    case mock
    
    var session: SessionManager {
        switch self {
        case .live: return RequestManager.shared.liveManager
        case .mock: return RequestManager.shared.mockManager
        }
    }
}
