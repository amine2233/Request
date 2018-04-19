//
//  UIImageViewExtension.swift
//  Request iOS
//
//  Created by Amine Bensalah on 19/04/2018.
//

import UIKit

extension UIImageView {
    func image(stringUtl: String?, placeholder: UIImage? = nil, activity: UIActivityIndicatorView? = nil) {
        
        guard let stringUtl = stringUtl else {
            self.image = placeholder
            return
        }
        
        if let data = DownloadCacheService.shared.get(key: stringUtl) {
            self.image = UIImage(data: data)
        } else {
            activity?.startAnimating()
            NetworkDownloadManager.shared.download(url: stringUtl) { (data, response, error) in
                DispatchQueue.main.async {
                    activity?.stopAnimating()
                    if let data = data {
                        DownloadCacheService.shared.add(key: stringUtl, data: data)
                        self.image = UIImage(data: data)
                    } else {
                        self.image = placeholder
                    }
                    if let error = error {
                        debugPrint("error:", error)
                        self.image = placeholder
                    }
                }
            }
        }
    }
}
