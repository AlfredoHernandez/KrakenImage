//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit

public class KrakenImageView: UIImageView {
    /// Displayed component when image is loading
    private(set) lazy var loadingControl: UIActivityIndicatorView = .init(style: .large)

    var showRetryIndicator: Bool = false {
        willSet {
            with(retryIndicator) { [newValue] in
                $0?.isHidden = !newValue
            }
        }
    }

    var imageAnimated = true

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
        if imageAnimated {
            setImageAnimated(UIImage(data: data))
        } else {
            image = UIImage(data: data)
        }
    }

    func setImage(_ image: UIImage) {
        if imageAnimated {
            setImageAnimated(image)
        } else {
            self.image = image
        }
    }
}

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage

        guard newImage != nil else { return }

        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
