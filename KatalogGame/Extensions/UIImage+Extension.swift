//
//  UIImage+Extension.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 06/11/24.
//

import UIKit

class ImageCached {
    static let shared = NSCache<NSString, UIImage>()

    private init() {
        ImageCached.shared.countLimit = 100
        ImageCached.shared.totalCostLimit = 1024 * 1024 * 100
    }
}

extension UIImageView {
    func load(url: URL?, placeholder: UIImage? = nil) {
        self.image = placeholder
        guard let url else {
            return
        }

        if let cachedImage = ImageCached.shared.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, err in
            guard let self = self else {return}

            if let err {
                print("error downloading image: \(err)")
                return
            }

            guard let data, let image = UIImage(data: data, scale: 0.5) else {
                print("error parsing image data")
                return
            }

            ImageCached.shared.setObject(   image, forKey: url.absoluteString as NSString, cost: data.count)

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
