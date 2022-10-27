//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit

class KrakenImageView: UIImageView {
    /// Displayed component when image is loading
    private(set) lazy var loadingControl: UIActivityIndicatorView = .init(style: .large)

    var showRetryIndicator: Bool = false {
        willSet {
            with(retryIndicator) { [newValue] in
                $0?.isHidden = !newValue
            }
        }
    }

    /// Component to retry download image
    private(set) lazy var retryIndicator: UIButton? = with(UIButton()) {
        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .bold))
        $0.isHidden = true
        $0.setImage(image, for: .normal)
        $0.imageView?.contentMode = .scaleToFill
        return $0
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(image: UIImage?) {
        super.init(image: image)
        self.image = image
        backgroundColor = .secondarySystemBackground
        configureDefaultLoadingControl()
        configureDefaultRetryIndicator()
    }

    private func configureDefaultLoadingControl() {
        addSubview(loadingControl)
        loadingControl.translatesAutoresizingMaskIntoConstraints = false
        loadingControl.contentMode = .center
        NSLayoutConstraint.activate([
            loadingControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingControl.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func configureDefaultRetryIndicator() {
        guard let retryIndicator = retryIndicator else { return }
        addSubview(retryIndicator)
        retryIndicator.translatesAutoresizingMaskIntoConstraints = false
        retryIndicator.contentMode = .center
        NSLayoutConstraint.activate([
            retryIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    func setImage(from data: Data) {
        image = UIImage(data: data)
    }

    func setImage(_ image: UIImage) {
        self.image = image
    }
}

public class KrakenImageViewController {
    private let loader: KrakenImageDataLoader
    private let url: URL?
    private var task: KrakenImageDataLoaderTask?
    private(set) var imageView = KrakenImageView(image: nil)

    private(set) var isLoading: Bool = false {
        willSet {
            with(imageView.loadingControl) { [newValue] in
                newValue ? $0.startAnimating() : $0.stopAnimating()
            }
        }
    }

    init(loader: KrakenImageDataLoader, url: URL?) {
        self.loader = loader
        self.url = url
    }

    /// Start loading image task
    func load() {
        guard let url = url else { return }
        isLoading = true
        imageView.showRetryIndicator = false
        task = loader.loadImageData(from: url) { [weak self] result in
            switch result {
            case let .success(imageData):
                self?.imageView.setImage(from: imageData)
            case .failure:
                self?.imageView.showRetryIndicator = true
            }
            self?.isLoading = false
        }
    }

    /// Cancels the current loading image task
    func cancel() {
        task?.cancel()
    }
}
