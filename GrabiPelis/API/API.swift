//
//  API.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/22/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Moya_ModelMapper
import Mapper

struct API {
    
    static func movieDB() -> APIMovieDB {
        return APIMovieDBLogic()
    }
    
}

public struct APIError: Mappable {
    
    var errors: [String]
    
    public init(map: Mapper) throws {
        errors = try map.from("errors")
    }
    
}
