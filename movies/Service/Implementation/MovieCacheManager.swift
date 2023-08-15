import Foundation

class MovieCacheManager: CacheManagerProtocol {    
    private let userDefaults = UserDefaults.standard
    private let moviesKey: String
    
    init(moviesKey: String) {
        self.moviesKey = moviesKey
    }

    func saveMovies(_ movies: [Movie]) {
        do {
            let encodedMovies = try JSONEncoder().encode(movies)
            userDefaults.set(encodedMovies, forKey: moviesKey)
        } catch {
            print("Error encoding movies: \(error)")
        }
    }

    func loadMovies() -> [Movie]? {
        guard let encodedMovies = userDefaults.data(forKey: moviesKey) else {
            return nil
        }

        do {
            let movies = try JSONDecoder().decode([Movie].self, from: encodedMovies)
            return movies
        } catch {
            print("Error decoding movies: \(error)")
            return nil
        }
    }
}
