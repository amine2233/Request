#if canImport(AppKit)
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
    public func image<T: EndPointType>(network: NetworkRouter<T>, router: T, placeholder: NSImage? = nil, activity: NSProgressIndicator? = nil) throws {
        activity?.startAnimation(self)
        try network.download(router) { data, _, error in
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
#endif
