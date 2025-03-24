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
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button
            .setImage(
                UIImage(
                    systemName: "square.and.arrow.up.circle",
                    withConfiguration: UIImage
                        .SymbolConfiguration(pointSize: 20)
                ),
                for: .normal
            )
        button.tintColor = .label
        return button
    }()
    
    private var shimmerView: UIView?
    
    // MARK: - Public Properties
        weak var delegate: ArticleCellDelegate?
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
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
        contentView.addSubview(shareButton)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.clipsToBounds = true
        
        newsImageView.pinTop(to: contentView.topAnchor)
        newsImageView.pinLeft(to: contentView.leadingAnchor)
        newsImageView.pinRight(to: contentView.trailingAnchor)
        newsImageView.setHeight(Constants.imageHeight)
        
        shareButton.pinTop(to: newsImageView.topAnchor,8)
        shareButton.pinRight(to: newsImageView.trailingAnchor,8)
        
        titleLabel.pinTop(to: newsImageView.bottomAnchor, Constants.titleTopPadding)
        titleLabel.pinLeft(to: contentView.leadingAnchor, Constants.horizontalPadding)
        titleLabel.pinRight(to: contentView.trailingAnchor, Constants.horizontalPadding)
        
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionTopPadding)
        descriptionLabel.pinLeft(to: contentView.leadingAnchor, Constants.horizontalPadding)
        descriptionLabel.pinRight(to: contentView.trailingAnchor, Constants.horizontalPadding)
        descriptionLabel.pinBottom(to: contentView.bottomAnchor, Constants.descriptionBottomPadding)
        descriptionLabel.setHeight(Constants.descriptionHeight)
    }
    
    private func setupActions() {
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    }

    @objc private func didTapShareButton() {
        delegate?.shareButtonTapped(in: self)
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
