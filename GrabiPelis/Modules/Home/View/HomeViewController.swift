//
//  HomeViewController.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/21/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import Moya
import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SVProgressHUD

class HomeViewController: UIViewController {

    let disposeBag = DisposeBag()
    var provider: MoyaProvider<MovieDB>!
    var viewModel: HomeViewModel!


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabBar: UITabBar!

    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true;
    }

    func setupUI() {
        tabBar.selectedItem = tabBar.items![0]
        tableView.rowHeight = tableView.frame.size.width * 0.4
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    func setupRx() {
        SVProgressHUD.show()

        viewModel.onError
            .drive(onNext: { errorMessage in
                SVProgressHUD.showError(withStatus: errorMessage)
            })
            .disposed(by: disposeBag)

        viewModel.moviesSuccess
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


        tableView.rx
            .itemSelected
            .subscribe(onNext: {
                [weak self] index in
                let movieID = self?.viewModel.movies.value[index.item].id
                let operation = MovieDetailOperation()
                operation.movieID = String(movieID!)
                operation.execute()
                //DefaultWireframe.presentAlert("Tapped `\(pair.1)` @ \(pair.0)")
            })
            .disposed(by: disposeBag)
        
        tabBar.rx.didSelectItem.subscribe({
            [weak self] item in
            let selectedIndex = self?.tabBar.items?.index(of: item.element!)?.distance(to: 0)
            self?.viewModel.loadMovies.on(.next((-selectedIndex!, 1)))
        }).disposed(by: disposeBag)

        searchBar
            .rx.searchButtonClicked
            .subscribe(onNext: {
                [unowned self] query in
                self.searchBar.endEditing(true)
                let query = self.searchBar.text!
                if(query.count > 0) {
                    self.searchBar.text = ""
                    let searchOperation = SearchOperation()
                    searchOperation.initialQuery = query
                    searchOperation.execute()
                }
            })
            .disposed(by: disposeBag)

        viewModel.loadMovies.on(.next((0, 1)))
    }

}
