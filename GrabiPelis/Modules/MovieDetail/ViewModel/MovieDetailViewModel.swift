//
//  MovieDetailViewModel.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/24/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Moya_ModelMapper

class MovieDetailViewModel {

    private let disposeBag = DisposeBag()

    //var movie: Driver<MMovie>!
    var movie = Variable<MMovie>(MMovie())
    var loadMovie = PublishSubject<Void>()
    var loadMovieSuccess: Driver<MMovie>!

    var onError: Driver<String>!


    convenience init(apiMovieDB: APIMovieDB, movieID: String) {
        self.init()

        let errorMessage = Variable("")
        
        /*movie = apiMovieDB
            .getMovie(id: movieID)
            .catchError({
                error in
                if let error = error as? MoyaError {
                    do {
                        let body = try error.response?.map(to: APIError.self)
                        errorMessage.value = (body?.errors[0])!
                    } catch {
                        errorMessage.value = "Unkown error"
                    }
                } else {
                    errorMessage.value = "Unkown error"
                }
                return Observable.never()
            })
            
            .asDriver { _ in Driver.never() }*/
        loadMovieSuccess = loadMovie
            .flatMapLatest{
                apiMovieDB.getMovie(id: movieID)
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
                self?.movie.value = $0
            })
            .asDriver(onErrorRecover: {_ in
                Driver.never()
            })

        onError = errorMessage
            .asDriver()
            .skip(1)


    }
}
