//
//  APIMovieDB.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/22/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import Foundation


import Foundation
import Then
import RxSwift
import Moya
import RxOptional
import Mapper
import Moya_ModelMapper
import RxDataSources

struct MoviePreview: Mappable {
    var voteCount: Int!
    var id: Int!
    var video: Bool!
    var voteAverage: Float!
    var title: String!
    var popularity: Float!
    var posterPath: String?
    var originalLanguage: String!
    var originalTitle: String!
    var genresIds: [Int] = []
    var backdropPath: String?
    var adult: Bool!
    var overview: String!
    var releaseDate: String!
    
    init(map: Mapper) throws {
        voteCount = try map.from("vote_count")
        id = try map.from("id")
        video = try map.from("video")
        voteAverage = try map.from("vote_average")
        title = try map.from("title")
        popularity = try map.from("popularity")
        posterPath = map.optionalFrom("poster_path")
        originalLanguage = try map.from("original_language")
        originalTitle = try map.from("original_title")
        genresIds = try map.from("genre_ids")
        backdropPath =  map.optionalFrom("backdrop_path")
        adult = try map.from("adult")
        overview = try map.from("overview")
        releaseDate = try map.from("release_date")
    }
}

struct Genre: Mappable {
    var id: Int!
    var name: String!
    
    init(map: Mapper) throws {
        id = try map.from("id")
        name = try map.from("name")
    }
}

struct MMovie: Mappable, Then {
    var id: Int!
    var title: String!
    var popularity: Float!
    var posterPath: String?
    var originalLanguage: String!
    var originalTitle: String!
    var genresIds: [Genre] = []
    var backdropPath: String?
    var adult: Bool!
    var overview: String!
    var releaseDate: String!
    
    init() {}
    
    init(map: Mapper) throws {
        id = try map.from("id")
        title = try map.from("title")
        popularity = try map.from("popularity")
        posterPath = map.optionalFrom("poster_path")
        originalLanguage = try map.from("original_language")
        originalTitle = try map.from("original_title")
        genresIds = try map.from("genres")
        backdropPath =  map.optionalFrom("backdrop_path")
        adult = try map.from("adult")
        overview = try map.from("overview")
        releaseDate = try map.from("release_date")
    }
}

struct MMovieList: Mappable, Then {
    var page: Int!
    var total_results: Int!
    var total_pages: Int!
    var results: [MoviePreview] = []
    
    init() {}
    init(map: Mapper) throws {
        page = try map.from("page")
        total_results = try map.from("total_results")
        total_pages = try map.from("total_pages")
        results = try map.from("results")
    }
}


protocol APIMovieDB {
    
    func getMovieList(list: Int, page: Int) -> Observable<MMovieList>
    
    func searchMovie(query: String) -> Observable<MMovieList>
    
    func getMovie(id: String) -> Observable<MMovie>
    
}

struct APIMovieDBLogic: APIMovieDB {
    
    let provider = MoyaProvider<MovieDB>()
    
    func getMovieList(list: Int, page: Int) -> Observable<MMovieList> {
        switch list {
        case 1:
            return provider.rx.request(.topRated(page: page))
                .asObservable()
                .filterSuccessfulStatusCodes()
                .map(to: MMovieList.self)
        case 2:
            return provider.rx.request(.upcoming(page: page))
                .asObservable()
                .filterSuccessfulStatusCodes()
                .map(to: MMovieList.self)
        default:
            return provider.rx.request(.popular(page: page))
                .asObservable()
                .filterSuccessfulStatusCodes()
                .map(to: MMovieList.self)
    
        }
    }
    
    func searchMovie(query: String) -> Observable<MMovieList> {
        return provider.rx.request(.search(query: query))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .map(to: MMovieList.self)
    }
    
    func getMovie(id: String) -> Observable<MMovie>{
        return provider.rx.request(.movie(id: id))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .map(to: MMovie.self)
        
    }
    
}
