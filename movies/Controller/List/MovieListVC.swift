//
//  ViewController.swift
//  movies
//
//  Created by Dávid Váradi on 2023. 08. 07..
//

import UIKit
import Reachability

class MovieListVC: UIViewController {
    private var movieListView = MovieListView()
    
    private var movies = [Movie]() {
        didSet {
            updateUI()
        }
    }
    
    private let movieService: MovieService
    private let networkManager: NetworkManager
    
    init(movieService: MovieService, networkManager: NetworkManager) {
        self.movieService = movieService
        self.networkManager = networkManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = movieListView
        
        setTitle()
        setBackButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setModel()
        setDelegates()
    }
    
    private func configureTableView() {
        movieListView.tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.id)
    }
    
    private func setModel() {
        if networkManager.isNetworkAvailable {
            fetchDataFromNetwork()
        } else {
            loadCachedMovies()
        }
    }
    
    private func fetchDataFromNetwork() {
        Task {
            movieListView.startLoading()
            await fetchGenres()
            await fetchMovies()
            movieListView.stopLoading()
        }
    }
    
    private func loadCachedMovies() {
        movies = movieService.getCachedMovies()
    }
    
    private func fetchGenres() async {
        do {
            try await movieService.getGenres()
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
    
    private func fetchMovies() async {
        do {
            movies = try await movieService.getMovies()
        } catch {
            print("Error fetching movies: \(error)")
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.movieListView.tableView.reloadData()
        }
    }
    
    private func setDelegates() {
        movieListView.tableView.dataSource = self
        movieListView.tableView.delegate = self
        movieListView.searchBar.delegate = self
    }
    
    private func setTitle() {
        title = "Movies"
        let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold)]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
    }
    
    private func setBackButton() {
        let button = UIBarButtonItem()
        button.tintColor = .white
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        navigationItem.backBarButtonItem = button
    }
}

extension MovieListVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.id, for: indexPath) as! MovieCell
        let movie = movies[indexPath.section]
        cell.setCell(movie: movie)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if movies.isEmpty { return }
        
        let movie = movies[indexPath.section]
        
        let movieVC = MovieVC()
        movieVC.setMovie(to : movie)
        navigationController?.pushViewController(movieVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        return headerView
    }
}

extension MovieListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        updateMovieList(with: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateMovieList(with: searchBar.text)
    }
    
    private func updateMovieList(with text: String?) {
        guard let text = text else { return }
        
        self.movies = movieService.filterMovies(with: text)
    }
}
