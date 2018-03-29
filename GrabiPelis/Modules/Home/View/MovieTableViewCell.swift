//
//  HomeMovieTableViewCell.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/22/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    @IBOutlet private weak var posterImageView:   UIImageView!
    @IBOutlet private weak var titleLabel:       UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override public var reuseIdentifier: String?{
        return "MovieTableViewCell"
    }
    
    func configureCell(movie: MoviePreview){
        titleLabel.text = movie.title
        dateLabel.text = movie.releaseDate
        ratingLabel.text = String(movie.voteAverage) + "\\10"
        genreLabel.text = "N/A"
        if let poster = movie.posterPath{
            let url = URL(string: "https://image.tmdb.org/t/p/w500/"+poster+"?api_key="+movieApiKey)
            posterImageView?.kf.setImage(with: url)
        }
        
    }


}



