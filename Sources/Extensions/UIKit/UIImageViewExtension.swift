#if canImport(UIKit)
import UIKit
import UIKit.UIImage
import UIKit.UIImageView
import UIKit.UIActivityIndicatorView

#if !os(watchOS)
// MARK: NetworkRouter UIImageView

public extension UIImageView {
    /**
     Request a new Image for showing in UIImageView

     - Parameter network: Use the appropriete network for download picture
     - Parameter router: Use the appropriete router for injected in network to set all properties to download picture
     - Parameter placeholder: Use placeholder picture if download failed or if can't get a picture data
     - Parameter activity: Use for show downloading progress
     */
    public func image<T: RequestProtocol>(network: NetworkRouter<T>, router: T, placeholder: UIImage? = nil, activity: UIActivityIndicatorView? = nil) throws {
        activity?.startAnimating()
        try network.download(router) { data, _, error in
            DispatchQueue.main.async {
                activity?.stopAnimating()
                if error != nil {
                    self.image = placeholder
                } else if let data = data {
                    self.image = UIImage(data: data)
                } else {
                    self.image = placeholder
                }
            }
        }
    }
}
#endif

#endif
