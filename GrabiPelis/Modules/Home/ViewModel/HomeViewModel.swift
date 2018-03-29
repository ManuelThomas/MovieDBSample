//
//  HomeViewModel.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/22/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Moya_ModelMapper

class HomeViewModel {
    
    private let disposeBag = DisposeBag()
    
    let loadMovies = PublishSubject<(Int,Int)>()
    var moviesSuccess: Driver<MMovieList>!
    var movies = Variable<[MoviePreview]>([])
    
    var onError: Driver<String>!

        
    convenience init(apiMovieDB: APIMovieDB) {
        self.init()
        
        let errorMessage = Variable("")
        
        moviesSuccess = loadMovies
            .flatMapLatest{
                apiMovieDB.getMovieList(list: $0.0, page: $0.1)
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
