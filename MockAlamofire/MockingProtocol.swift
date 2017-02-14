//
//  MockingProtocol.swift
//  MockAlamofire
//
//  Created by Steigerwald, Kris S. (CONT) on 2/13/17.
//  Copyright © 2017 Velaru. All rights reserved.
//

import Foundation
import Alamofire

class MockingURLProtocol: URLProtocol {
    
    let mocks:Mocks = Mocks()
    
    var cannedResponse: NSData?
    let cannedHeaders = ["Content-Type" : "application/json; charset=utf-8"]
    
    // MARK: Properties
    struct PropertyKeys {
        static let handledByForwarderURLProtocol = "HandledByProxyURLProtocol"
    }
    
    lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            
            return configuration
        }()
        
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        return session
    }()
    
    var activeTask: URLSessionTask?
    
    // MARK: Class Request Methods
    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: PropertyKeys.handledByForwarderURLProtocol, in: request) != nil {
            return false
        }
        
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        if let headers = request.allHTTPHeaderFields {
            do {
                return try URLEncoding.default.encode(request, with: headers)
            } catch {
                return request
            }
        }
        
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    // MARK: Loading Methods
    override func startLoading() {
        let data:NSData = mocks.find(request) as! NSData
        let client = self.client
        let response = HTTPURLResponse(url: (request.url)!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: cannedHeaders)
        
        client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
        cannedResponse = data
        client?.urlProtocol(self, didLoad: cannedResponse as! Data)
        client?.urlProtocolDidFinishLoading(self)
        
        activeTask?.resume()
    }
    
    override func stopLoading() {
        activeTask?.cancel()
    }
}

extension MockingURLProtocol: URLSessionDelegate {
    
    // MARK: NSURLSessionDelegate
    func URLSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceiveData data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func URLSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let response = task.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
}
