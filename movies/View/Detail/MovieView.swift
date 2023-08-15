//
//  MovieView.swift
//  movies
//
//  Created by Dávid Váradi on 2023. 08. 07..
//

import UIKit

class MovieView: UIView {
    // Image of the movie
    private let backgroundView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 42)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "star.fill"))
        image.tintColor = .systemYellow
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dataView: DataView = {
        let dataView = DataView()
        dataView.translatesAutoresizingMaskIntoConstraints = false
        return dataView
    }()
    
    private let genreScrollView: GenreScrollView = {
        let scrollView = GenreScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = UIColor(white: 1, alpha: 0)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .systemGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
//  Called by the controller, fills up the properties with values from the 'movie' parameter
    func setView(with movie: Movie?) {
        guard let movie = movie else { return }
        
        setGenreScrollView(with: movie)
        setDataView(with: movie)
        setView(with: movie)
    }
    
    private func setGenreScrollView(with movie: Movie) {
        genreScrollView.setupLabels(with: movie.genres)
    }
    
    private func setDataView(with movie: Movie) {
        let status      = movie.mediaType.uppercasedFirstLetter()
        let popularity  = String(movie.popularity)
        let language    = movie.originalLanguage.uppercased()
        
        dataView.setLabelsText(status: status, popularity: popularity, language: language)
    }
    
    private func setView(with movie: Movie) {
        let roundedVoteAvarage = round(movie.voteAverage * 100) / 100
        let image = UIImage(data: movie.imageData)
        
        DispatchQueue.main.async {
            self.backgroundView.image     = image
            self.titleLabel.text          = movie.title
            self.ratingLabel.text         = String(roundedVoteAvarage)
            self.descriptionTextView.text = movie.overview
        }
    }

    private func setupView() {
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(starImage)
        addSubview(ratingLabel)
        addSubview(dataView)
        addSubview(genreScrollView)
        addSubview(descriptionTextView)
        
        backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2.0/3.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: ratingLabel.topAnchor, constant: -4),
            
            starImage.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            starImage.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
            
            ratingLabel.leadingAnchor.constraint(equalTo: starImage.trailingAnchor, constant: 8),
            ratingLabel.topAnchor.constraint(equalTo: starImage.topAnchor),
            
            dataView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dataView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dataView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            
            genreScrollView.leadingAnchor.constraint(equalTo: dataView.leadingAnchor),
            genreScrollView.trailingAnchor.constraint(equalTo: dataView.trailingAnchor),
            genreScrollView.topAnchor.constraint(equalTo: dataView.bottomAnchor, constant: 8),
            genreScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: dataView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: dataView.trailingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: genreScrollView.bottomAnchor, constant: 8),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

