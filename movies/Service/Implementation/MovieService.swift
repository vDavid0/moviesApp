//
//  MovieService.swift
//  movies
//
//  Created by Dávid Váradi on 2023. 08. 07..
//
import Foundation
import UIKit

enum CFError: String, Error {
    case invalidResponse = "Invalid response"
    case invalidUrl = "Invalid Url"
    case invalidJSON = "Error with decoding the json"
}

class MovieService: MovieServiceProtocol {
    private var _genres = [Genre]()
    private var _movies = [Movie]() {
        didSet {
            movieCacheManager.saveMovies(movies)
        }
    }
    
    var genres: [Genre] {
        return _genres
    }
    
    var movies: [Movie] {
        return _movies
    }
    
    private let apiKey: String = ProcessInfo.processInfo.environment["TMDB_API_KEY"]!
    
    private let preferredLanguage = Locale.preferredLanguages.first ?? "en-US"
    
    private lazy var languageCode: String = {
        return preferredLanguage.extractPrimaryLanguageCode() ?? "en"
    }()
    
    private lazy var movieEndpoint: String = {
        return "https://api.themoviedb.org/3/trending/movie/day?language=\(preferredLanguage)"
    }()
    
    private lazy var genreEndpoint: String = {
        return "https://api.themoviedb.org/3/genre/movie/list?language=\(languageCode)"
    }()
    
    private var movieCacheManager: MovieCacheManager
    
    init(cacheManager: MovieCacheManager) {
        self.movieCacheManager = cacheManager
    }
    
    //  Fetches the movies and returns the array of them
    func getMovies() async throws -> [Movie] {
        guard let url = URL(string: movieEndpoint) else {
            throw CFError.invalidUrl
        }
        
        let request = getAuthorizedRequest(with: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CFError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            let movieResponse = try decoder.decode(MovieResponse.self, from: data)
            
            self._movies = await mapMovies(from: movieResponse.results)
            
            return movies
            
        } catch {
            throw CFError.invalidJSON
        }
    }
    
    func getCachedMovies() -> [Movie] {
        _movies = movieCacheManager.loadMovies() ?? [Movie]()
        
        return movies
    }
    
    //  Fetches all the genres (id, name pairs) and fills the genres array with them
    func getGenres() async throws {
        guard let url = URL(string: genreEndpoint) else {
            throw CFError.invalidResponse
        }
        
        let request = getAuthorizedRequest(with: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CFError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            let genreResponse = try decoder.decode(GenreResponse.self, from: data)
            _genres = genreResponse.genres
        } catch {
            throw CFError.invalidJSON
        }
    }
    
    func filterMovies(with prefix: String) -> [Movie] {
        let allMovies = movies
        
        guard !allMovies.isEmpty else { return [Movie]() }
        
        return allMovies.filter { $0.title.hasPrefix(prefix) }
    }
    
    private func getAuthorizedRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
    // Creates Movie objects from MovieDTO's and returns it
    private func mapMovies(from moviesDTO: [MovieDTO]) async -> [Movie] {
        var movies = [Movie]()
        
        for dto in moviesDTO {
            do {
                let imageData = try await getImageData(of: dto)
                let genres = mapGenres(with: dto.genreIds)
                let movie = Movie(from: dto, imageData: imageData, genres: genres)
                movies.append(movie)
            } catch {
                print("Error fetching image: \(error)")
            }
        }
        
        return movies
    }
    
    //  Returns the image (from posterPath attribute) of a movie as Data
    private func getImageData(of movie: MovieDTO) async throws -> Data {
        guard let posterPath = movie.posterPath, !posterPath.isEmpty else {
            throw CFError.invalidUrl
        }
        
        let imageURLString = "https://image.tmdb.org/t/p/original\(posterPath)"
        
        guard let imageURL = URL(string: imageURLString) else { throw CFError.invalidUrl }
        
        var request = URLRequest(url: imageURL)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        }
        catch {
            throw CFError.invalidResponse
        }
    }
    
    //  Returns the genres of a movie, based on its genreIds
    private func mapGenres(with ids: [Int]) -> [String] {
        var movieGenres = [String]()
        
        for genre in genres {
            if ids.contains(genre.id) {
                movieGenres.append(genre.name)
            }
        }
        
        return movieGenres
    }
}
