//
//  movie.swift
//  movies
//
//  Created by Dávid Váradi on 2023. 08. 07..
//

import Foundation

struct Movie: Codable {
    var imageData: Data
    var title: String
    var voteAverage: Double
    var voteCount: Int
    var overview: String
    var mediaType: String
    var popularity: Double
    var originalLanguage: String
    var genres: [String]
    
    
    init(from movieDTO: MovieDTO, imageData: Data, genres: [String]) {
        self.imageData = imageData
        self.title = movieDTO.title
        self.voteAverage = movieDTO.voteAverage
        self.voteCount = movieDTO.voteCount
        self.overview = movieDTO.overview
        self.mediaType = movieDTO.mediaType
        self.popularity = movieDTO.popularity
        self.originalLanguage = movieDTO.originalLanguage
        self.genres = genres
    }
}
