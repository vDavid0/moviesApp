protocol CacheManagerProtocol {
    func saveMovies(_ movies: [Movie])
    func loadMovies() -> [Movie]?
}
