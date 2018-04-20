//
//  UIImageViewExtension.swift
//  Request iOS
//
//  Created by Amine Bensalah on 19/04/2018.
//

import UIKit

public extension UIImageView {
    public func image<T: EndPointType>(network: NetworkRouter<T>, router: T, placeholder: UIImage? = nil, activity: UIActivityIndicatorView? = nil) {
        activity?.startAnimating()
        network.download(router) { (data, response, error) in
            DispatchQueue.main.async {
                activity?.stopAnimating()
                if let data = data {
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
