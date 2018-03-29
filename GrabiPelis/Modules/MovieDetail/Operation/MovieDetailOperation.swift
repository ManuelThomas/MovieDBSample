//
//  MovieDetailOperation.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/24/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class MovieDetailOperation: Operation {
    
    
    weak var navigationController: UINavigationController?
    var movieID: String!
    
    override init(type: OperationType) {
        super.init(type: .main)
        self.navigationController = appDelegate.navigationController
    }
    
    override func main() {
        assert(movieID != nil)
        self.navigationController?.navigationBar.isHidden = false
        let viewModel = MovieDetailViewModel(apiMovieDB: API.movieDB(), movieID: movieID)
        let vc = MovieDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

