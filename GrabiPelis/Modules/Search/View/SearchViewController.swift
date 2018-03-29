//
//  SearchViewController.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/28/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD


class SearchViewController: UIViewController {

    
    let disposeBag = DisposeBag()
    var viewModel: SearchViewModel!
    var initialQuery: String!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    convenience init(viewModel: SearchViewModel, initialQuery: String) {
        self.init()
        self.viewModel = viewModel
        self.initialQuery = initialQuery
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    
    func setupUI() {
        searchBar.text = initialQuery
        tableView.rowHeight = tableView.frame.size.width * 0.4
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }

    func setupRx(){
        
        viewModel.searchMoviesSucess
            .drive(onNext: {
                _ in
                SVProgressHUD.dismiss()
            })
            .disposed(by: disposeBag)
        
        viewModel.movies.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "MovieTableViewCell", cellType: MovieTableViewCell.self)) {
                row, element, cell in
                cell.configureCell(movie: element)
            }
            .disposed(by: disposeBag)
        
        searchBar
            .rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                [unowned self] query in
                if(query.count > 0) {
                    self.viewModel.searchMovies.onNext(query)
                }
            }).disposed(by: disposeBag)
        
        searchBar
            .rx.searchButtonClicked
            .subscribe(onNext: {
                [unowned self] query in
                self.searchBar.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        viewModel.searchMovies.onNext(initialQuery)
    }
}
