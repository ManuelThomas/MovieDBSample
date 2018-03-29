//
//  MovieDetailViewController.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/24/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD
import Moya

class MovieDetailViewController: UIViewController {

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var overviewTextView: UITextView!


    let disposeBag = DisposeBag()
    var provider: MoyaProvider<MovieDB>!
    var viewModel: MovieDetailViewModel!

    convenience init(viewModel: MovieDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }


    func setupRx() {

        SVProgressHUD.show()

        viewModel.onError
            .drive(onNext: { errorMessage in
                SVProgressHUD.showError(withStatus: errorMessage)
            })
            .disposed(by: disposeBag)
        
        viewModel.loadMovieSuccess
            .drive(onNext: {
                _ in
                SVProgressHUD.dismiss()
            })
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable().bind(onNext: {
            [weak self] movie in
            self?.titleLabel.text = movie.title
            self?.yearLabel.text = movie.releaseDate
            self?.overviewTextView.text = movie.overview
            
            if let poster = movie.posterPath{
                let url = URL(string: "https://image.tmdb.org/t/p/w500/"+poster+"?api_key="+movieApiKey)
                self?.posterImageView?.kf.setImage(with: url)
            }
            if let backdrop = movie.backdropPath{
                let url = URL(string: "https://image.tmdb.org/t/p/w500/"+backdrop+"?api_key="+movieApiKey)
                self?.backgroundImageView?.kf.setImage(with: url)
            }
            
        }).disposed(by: disposeBag)
        viewModel.loadMovie.on(.next(()))
        /*iewModel.movie
            .drive(onNext: {
                [weak self] movie in
                SVProgressHUD.dismiss()
                self?.titleLabel.text = movie.title
                self?.yearLabel.text = movie.releaseDate
                self?.overviewTextView.text = movie.overview
                
                if let poster = movie.posterPath{
                    let url = URL(string: "https://image.tmdb.org/t/p/w500/"+poster+"?api_key="+movieApiKey)
                    self?.posterImageView?.kf.setImage(with: url)
                }
                if let backdrop = movie.backdropPath{
                    let url = URL(string: "https://image.tmdb.org/t/p/w500/"+backdrop+"?api_key="+movieApiKey)
                    self?.backgroundImageView?.kf.setImage(with: url)
                }
                
            })
            .disposed(by: disposeBag)*/

    }


}
