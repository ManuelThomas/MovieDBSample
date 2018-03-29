//
//  SearchViewModel.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/28/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Moya_ModelMapper

class SearchViewModel {
    
    private let disposeBag = DisposeBag()
    
    var onError: Driver<String>!
    let searchMovies = PublishSubject<(String)>()
    var searchMoviesSucess: Driver<MMovieList>!
    
    var movies = Variable<[MoviePreview]>([])
    
    convenience init(apiMovieDB: APIMovieDB) {
        self.init()
        
        let errorMessage = Variable("")
        
        searchMoviesSucess = searchMovies
            .flatMapLatest{
                apiMovieDB.searchMovie(query: $0)
                    .catchError({
                        error in
                        if let error = error as? MoyaError {
                            do {
                                let body = try error.response?.map(to: APIError.self)
                                errorMessage.value = (body?.errors[0])!
                            } catch {
                                errorMessage.value = "Unkown error"
                            }
                        }else{
                            errorMessage.value = "Unkown error"
                        }
                        return Observable.never()
                    })
            }
            .do(onNext: { [weak self] in
                self?.movies.value = $0.results
            })
            .asDriver(onErrorRecover: {_ in
                Driver.never()
            })
        
        onError = errorMessage
            .asDriver()
            .skip(1)
        
        
    }
}
