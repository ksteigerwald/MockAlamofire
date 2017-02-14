//
//  Mocks.swift
//  MockAlamofire
//
//  Created by Steigerwald, Kris S. (CONT) on 2/13/17.
//  Copyright © 2017 Velaru. All rights reserved.
//

import Foundation

enum MockDirection {
    case GET, PUT, POST
    
    init(str: String) {
        switch str {
        case "GET":
            self = .GET
        case "PUT":
            self = .PUT
        case "POST":
            self = .POST
        default:
            self = .GET
        }
    }
    
    func isNotToken(_ item: String) -> Bool {
        let num = Int(item)
        return num == nil
    }
    
    func kind(_ tokens: Array<String> = []) ->  [String] {
        
        if(isNotToken(tokens.last!) && self == .GET) {
            //Is a index actionk
            return [tokens.last!, self.output.last!]
        }
        
        if(!isNotToken(tokens.last!) && self == .GET) {
            //Is a show action
            return [tokens.first!, self.output.first!]
        }
        
        if(isNotToken(tokens.last!) && self == .POST) {
            //Is a create action
            return [tokens.last!, self.output.first!]
        }
        
        return [tokens.first!, output.last!]
    }
    
    var output:Array<String> {
        switch self {
        case .GET: return ["SHOW", "INDEX"]
        case .PUT: return ["UPDATE"]
        case .POST: return ["CREATE"]
        }
    }
    
    
}

struct Mocks {
    
    var mocks: Dictionary = [
        "todos": [
            "INDEX": "[{ \"userId\": 1, \"id\": 1, \"title\": \"delectus aut autem\", \"completed\": false }, { \"userId\": 1, \"id\": 2, \"title\": \"quis ut nam facilis et officia qui\", \"completed\": false }]",
            "SHOW": "{ \"userId\": 1, \"id\": 1, \"title\": \"delectus aut autem\", \"completed\": false }"
            
        ]
    ]
    
    func index(_ resource: String, action: String) -> String {
        let hasKey:Bool = mocks[resource] != nil
        
        guard hasKey else {
            print("FAILED TO FIND KEY")
            return ""
        }
        
        let book = mocks[resource]!
        let hasAction:Bool = book[action] != nil
        
        guard hasAction else {
            print("FAILED TO FIND RESOURCE ACTION, PLEASE INCLUDE MOCK")
            return ""
        }
        
        return book[action]!
    }
    
    func find(_ request: URLRequest ) -> AnyObject {
        
        let parts:Array<String> = (request.url?.pathComponents)!
        
        let method:String = request.httpMethod!
        
        let direction:MockDirection = MockDirection(str: method)
        
        let suffix:[String] = parts.suffix(2).map{ i in return i}
        
        let actions = direction.kind(suffix)
        
        let loadJSON:String = index(actions[0], action: actions[1])
        
        return (loadJSON.data(using: String.Encoding.utf8) as NSData?)!
    }
    
}
