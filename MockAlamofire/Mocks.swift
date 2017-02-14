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
        "sessions": [
            "INDEX": "{ \"records\": [ { \"cafeId\": 1, \"clientId\": 4, \"updatedAt\": 1485277932159, \"sessionId\": 4, \"bookingId\": \"28-896-3640\", \"loggedAt\": 1485165510000, \"createdAt\": 1485277932159, \"eid\": \"jit100\", \"visitNumber\": \"90-983-7620\" }, { \"cafeId\": 1, \"clientId\": 5, \"updatedAt\": 1485277932214, \"sessionId\": 5, \"bookingId\": \"35-093-2819\", \"loggedAt\": 1485232046000, \"createdAt\": 1485277932214, \"eid\": \"fsw700\", \"visitNumber\": \"07-619-9775\" } ] }",
            "SHOW": "{ \"cafeId\": 1, \"clientId\": 100, \"updatedAt\": 1485792152345, \"sessionId\": 1, \"bookingId\": \"string\", \"loggedAt\": 0, \"createdAt\": 1485277931995, \"eid\": \"string\", \"visitNumber\": \"string\" }",
            "CREATE": "{ \"sessionId\": 10 }",
            "UPDATE": "{ \"sessionId\": 10 }"],
        "clients": [
            "INDEX": "{ \"records\": [ { \"clientId\": 3, \"first\": \"Kale\", \"last\": \"Green\", \"email\": \"murray.fahey@vandervortwolff.info\", \"createdAt\": 1485277922305, \"updatedAt\": 1485277922305 }, { \"clientId\": 4, \"first\": \"Jensen\", \"last\": \"Frami\", \"email\": \"jazmyne_zemlak@connbruen.io\", \"createdAt\": 1485277922342, \"updatedAt\": 1485277922342 }] }",
            "SHOW": "{ \"clientId\": 1, \"first\": \"Mocking\", \"last\": \"Bird\", \"email\": \"mocking@bird.com\", \"createdAt\": 1485277922217, \"updatedAt\": 1485792025698 }",
            "CREATE": "{ \"clientId\": 1 }",
            "UPDATE": "{ \"clientId\": 1 }"
        ],
        "worksheets": [
            "INDEX" : "{ \"records\": [ { \"worksheetId\": 643, \"sessionId\": 1, \"worksheetTypeId\": 1, \"createdAt\": 1485376407085, \"updatedAt\": 1485376407086 }, { \"worksheetId\": 644, \"sessionId\": 1, \"worksheetTypeId\": 1, \"createdAt\": 1485376455302, \"updatedAt\": 1485376455302 }]}",
            "SHOW" : "{ \"worksheetId\": 643, \"sessionId\": 1, \"worksheetTypeId\": 1, \"createdAt\": 1485376407085, \"updatedAt\": 1485376407086 }",
            "CREATE": "{ \"worksheetId\": 643 }",
            "UPDATE": "{ \"worksheetId\": 643 }"
        ],
        "worksheets-logs": [
            "INDEX" : "{ \"records\": [] }",
            "SHOW" : "{ \"worksheetLogId\": 777, \"worksheetId\": 643, \"worksheetEventId\": 1, \"data\": \"{\\\"stickers\\\":[[490,70],[90,391],[476,657],[573,228],[194,249],[238,70],[82,496],[182,707],[229,476],[405,402],[858,650],[399,53]]}\", \"path\": \"somes3path\", \"createdAt\": 1485277952857, \"updatedAt\": 1485277952857 }",
            "CREATE": "{ \"worksheetLogId\": 777 }",
            "UPDATE": "{ \"worksheetLogId\": 777 }"
        ],
        "client-session": [
            "CREATE": "{ \"clientId\": 1, \"sessionId\": 1 }"
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
