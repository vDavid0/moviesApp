import Foundation

protocol MovieServiceProtocol {
    var genres: [Genre] { get }
    var movies: [Movie] { get }
    
    func getMovies() async throws -> [Movie]
    func getCachedMovies() -> [Movie]
    func getGenres() async throws
    
    // Returns an array of movies from the 'movies' attribute that have a title starting with the prefix provided in the parameter.
    func filterMovies(with prefix: String) -> [Movie]
}
