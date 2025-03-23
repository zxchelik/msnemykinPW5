import UIKit

final class ArticleCell: UITableViewCell {
    
    private enum Constants {
        static let cornerRadius: CGFloat = 30
        static let imageHeight: CGFloat = 225
        static let titleTopPadding: CGFloat = 8
        static let horizontalPadding: CGFloat = 12
        static let descriptionTopPadding: CGFloat = 4
        static let descriptionBottomPadding: CGFloat = 12
        static let shimmerAlpha: CGFloat = 0.3
        static let shimmerColor: UIColor = .lightGray
        static let defaultImageName: String = "photo"
        static let titleFontSize: CGFloat = 16
        static let descriptionFontSize: CGFloat = 14
        static let maxTitleLines = 2
        static let maxDescriptionLines = 3
        static let descriptionHeight: CGFloat = 30
        static let contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    // MARK: - UI Elements
    private let newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        label.numberOfLines = Constants.maxTitleLines
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        label.numberOfLines = Constants.maxDescriptionLines
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var shimmerView: UIView?
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: Constants.contentInset)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.clipsToBounds = true
        
        newsImageView.pinTop(to: contentView.topAnchor)
        newsImageView.pinLeft(to: contentView.leadingAnchor)
        newsImageView.pinRight(to: contentView.trailingAnchor)
        newsImageView.setHeight(Constants.imageHeight)
        
        titleLabel.pinTop(to: newsImageView.bottomAnchor, Constants.titleTopPadding)
        titleLabel.pinLeft(to: contentView.leadingAnchor, Constants.horizontalPadding)
        titleLabel.pinRight(to: contentView.trailingAnchor, Constants.horizontalPadding)
        
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionTopPadding)
        descriptionLabel.pinLeft(to: contentView.leadingAnchor, Constants.horizontalPadding)
        descriptionLabel.pinRight(to: contentView.trailingAnchor, Constants.horizontalPadding)
        descriptionLabel.pinBottom(to: contentView.bottomAnchor, Constants.descriptionBottomPadding)
        descriptionLabel.setHeight(Constants.descriptionHeight)
    }
    
    // MARK: - Configure Cell
    func configure(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.announce
        
        showShimmer()
        
        if let url = article.img?.url {
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        self.newsImageView.image = image
                    } else {
                        self.newsImageView.image = UIImage(systemName: Constants.defaultImageName)
                    }
                    self.hideShimmer()
                }
            }
        } else {
            newsImageView.image = UIImage(systemName: Constants.defaultImageName)
            hideShimmer()
        }
    }
    
    // MARK: - Shimmer Effect
    private func showShimmer() {
        let shimmer = UIView(frame: newsImageView.bounds)
        shimmer.backgroundColor = Constants.shimmerColor.withAlphaComponent(Constants.shimmerAlpha)
        shimmer.isUserInteractionEnabled = false
        newsImageView.addSubview(shimmer)
        shimmer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shimmerView = shimmer
    }
    
    private func hideShimmer() {
        shimmerView?.removeFromSuperview()
        shimmerView = nil
    }
}
