import UIKit

class GenreScrollView: UIScrollView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupLabels(with genres: [String]) {
        removeAllGenreLabels()
        
        for genre in genres {
            createGenreLabel(with: genre)
        }
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(stackView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func removeAllGenreLabels() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func createGenreLabel(with text: String) {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .systemRed
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        stackView.addArrangedSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
