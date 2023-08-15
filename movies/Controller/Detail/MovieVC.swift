//
//  MovieVC.swift
//  movies
//
//  Created by Dávid Váradi on 2023. 08. 07..
//

import UIKit

class MovieVC: UIViewController {
    var movieView = MovieView()
    
    private var movie: Movie? {
        didSet {
            updateUI()
        }
    }
    
    override func loadView() {
        view = movieView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setMovie(to movie: Movie) {
        self.movie = movie
    }
    
    private func updateUI() {
        movieView.setView(with: movie)
    }
}
