//
//  NSImageView.swift
//  Request macOS
//
//  Created by Amine Bensalah on 20/04/2018.
//

import AppKit

// MARK: NetworkRouter NSImageView
extension NSImageView {
    
    /**
     Request a new Image for showing in NSImageView
     
     - Parameter network: Use the appropriete network for download picture
     - Parameter router: Use the appropriete router for injected in network to set all properties to download picture
     - Parameter placeholder: Use placeholder picture if download failed or if can't get a picture data
     - Parameter activity: Use for show downloading progress
    */
    public func image<T: EndPointType>(network: NetworkRouter<T>, router: T, placeholder: NSImage? = nil, activity: NSProgressIndicator? = nil) {
        activity?.startAnimation(self)
        network.download(router) { (data, response, error) in
            DispatchQueue.main.async {
                activity?.stopAnimation(self)
                if error != nil {
                    self.image = placeholder
                } else if let data = data {
                    self.image = NSImage(data: data)
                } else {
                    self.image = placeholder
                }
            }
        }
    }
}