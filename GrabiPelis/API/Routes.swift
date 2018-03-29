//
//  API.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/22/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Moya

enum MovieDB {
    case popular(page: Int)
    case topRated(page: Int)
    case upcoming(page: Int)
    case search(query: String)
    case movie(id: String)
}

// MARK: - TargetType Protocol Implementation
extension MovieDB: TargetType {
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var baseURL: URL { return URL(string: "https://api.themoviedb.org/3")! }
    
    var path: String {
        switch self {
        case .popular:  return "/movie/popular"
        case .topRated:  return "/movie/top_rated"
        case .upcoming:  return "/movie/upcoming"
        case .search:  return "/search/movie"
        case .movie(let id):  return ("/movie/" + id)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .popular, .topRated, .upcoming, .search, .movie:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .popular(let page):
            return .requestParameters(parameters: ["api_key": movieApiKey,"page":page], encoding: URLEncoding.queryString)
        case .topRated(let page):
            return .requestParameters(parameters: ["api_key": movieApiKey,"page":page], encoding: URLEncoding.queryString)
        case .upcoming(let page):
            return .requestParameters(parameters: ["api_key": movieApiKey,"page":page], encoding: URLEncoding.queryString)
        case .search(let query):
            return .requestParameters(parameters: ["api_key": movieApiKey,"query":query], encoding: URLEncoding.queryString)
        case .movie:
            return .requestParameters(parameters: ["api_key": movieApiKey], encoding: URLEncoding.queryString)
        }
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}


