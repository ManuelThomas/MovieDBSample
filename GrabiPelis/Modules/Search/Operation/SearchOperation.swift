//
//  SearchOperation.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/28/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class SearchOperation: Operation {
    
    
    weak var navigationController: UINavigationController?
    var initialQuery: String!
    
    override init(type: OperationType) {
        super.init(type: .main)
        self.navigationController = appDelegate.navigationController
    }
    
    override func main() {
        self.navigationController?.navigationBar.isHidden = false
        let viewModel = SearchViewModel(apiMovieDB: API.movieDB())
        let vc = SearchViewController(viewModel: viewModel, initialQuery: initialQuery)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
