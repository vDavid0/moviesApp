//
//  MovieCell.swift
//  movies
//
//  Created by Dávid Váradi on 2023. 08. 07..
//

import UIKit

class MovieCell: UITableViewCell {
    static let id = String(describing: MovieCell.self)
    
    private let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(3))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .systemYellow
        button.setTitleColor(.systemYellow, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let likesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
        button.tintColor = .red
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = UIColor(white: 1, alpha: 0)
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = .systemGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .secondarySystemGroupedBackground
        setupView()
    }
    
    override func layoutSubviews() {
        setupShadow()
    }
    
    func setCell(movie: Movie) {
        resetCell()
        
        let roundedVoteAverage = round(movie.voteAverage * 100) / 100
        
        DispatchQueue.main.async {
            self.pictureImageView.image = UIImage(data: movie.imageData)
            self.titleLabel.text = movie.title
            self.descriptionTextView.text = movie.overview
            self.ratingButton.setTitle(String(roundedVoteAverage), for: .normal)
            self.likesButton.setTitle(String(movie.voteCount), for: .normal)
        }
    }
    
    private func resetCell() {
        DispatchQueue.main.async {
            self.pictureImageView.image = nil
            self.titleLabel.text = ""
            self.descriptionTextView.text = ""
            self.ratingButton.setTitle("", for: .normal)
            self.likesButton.setTitle("", for: .normal)
        }
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
    }
    
    private func setupView() {
        contentView.addSubview(pictureImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingButton)
        contentView.addSubview(likesButton)
        contentView.addSubview(descriptionTextView)
        
        layer.cornerRadius = 20
        
        setupLayout()
    }
    
    private func setupLayout() {
        let padding: CGFloat = 16
        let smallPadding: CGFloat = padding / 2
        
        NSLayoutConstraint.activate([
            pictureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            pictureImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -padding),
            pictureImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding),
            pictureImageView.widthAnchor.constraint(equalToConstant: 120),
            pictureImageView.heightAnchor.constraint(equalToConstant: 170),
            
            titleLabel.leadingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            
            ratingButton.leadingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: padding),
            ratingButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: smallPadding),
            
            likesButton.leadingAnchor.constraint(equalTo: ratingButton.trailingAnchor, constant: smallPadding),
            likesButton.topAnchor.constraint(equalTo: ratingButton.topAnchor),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: padding),
            descriptionTextView.topAnchor.constraint(equalTo: likesButton.bottomAnchor, constant: smallPadding),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            descriptionTextView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

