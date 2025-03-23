import UIKit
import WebKit

final class NewsDetailViewController: UIViewController, NewsDetailViewProtocol {
    
    var presenter: NewsDetailPresenterProtocol!
    
    private enum Constants {
        static let viewTitle = "Подробности"
    }
    
    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = Constants.viewTitle
        
        setupWebView()
        presenter.viewDidLoad()
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.pinVertical(to: view)
        webView.pinHorizontal(to: view)
    }
    
    // MARK: - NewsDetailViewProtocol
    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
