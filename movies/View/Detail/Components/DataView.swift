import UIKit

// Component of a movie items view, displays Status, Popularity, Language
class DataView: UIView {
    private let statusValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let popularityValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dividerView1: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dividerView2: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Horizontal stack that containts all the properties of the class (embedded into 3 vertical stacks)
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setLabelsText(status: String, popularity: String, language: String) {
        DispatchQueue.main.async {
            self.statusValueLabel.text     = status
            self.popularityValueLabel.text = popularity
            self.languageValueLabel.text   = language
        }
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(createLabelStackView(title: "Status", valueLabel: statusValueLabel))
        stackView.addArrangedSubview(dividerView1)
        stackView.addArrangedSubview(createLabelStackView(title: "Popularity", valueLabel: popularityValueLabel))
        stackView.addArrangedSubview(dividerView2)
        stackView.addArrangedSubview(createLabelStackView(title: "Language", valueLabel: languageValueLabel))
        
        setupLayout()
    }
    
    // Returns a vertical stackview
    private func createLabelStackView(title: String, valueLabel: UILabel) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        
        let titleLabel = UILabel()
        titleLabel.textColor = .systemGray
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        
        return stackView
    }
    
    private func setupLayout() {
        let padding: CGFloat = 16
        let dividerWidth: CGFloat = 2
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
        
        dividerView1.widthAnchor.constraint(equalToConstant: dividerWidth).isActive = true
        dividerView2.widthAnchor.constraint(equalToConstant: dividerWidth).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
