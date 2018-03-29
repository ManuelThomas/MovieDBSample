//
//  HomeOperation.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/21/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class HomeOperation: Operation {
    
    
    weak var navigationController: UINavigationController?
    
    override init(type: OperationType) {
        super.init(type: .main)
        self.navigationController = appDelegate.navigationController
    }
    
    override func main() {
        
        let viewModel = HomeViewModel(apiMovieDB: API.movieDB())
        let vc = HomeViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
