import UIKit

extension UIImageView {
    
    // MARK: - Constants
    
    private struct AssociationKey {
        static var dataTask = "pos_dataTask"
        static var session = "pos_imageDownloadSession"
    }
    
    // MARK: - Static Properties
    public static let downloadSession = URLSession(configuration: .default)
    
    // MARK: - Instance Properties
    public var dataTask: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &AssociationKey.dataTask) as? URLSessionDataTask
        } set {
            dataTask?.cancel()
            objc_setAssociatedObject(self, &AssociationKey.dataTask, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Instance Methods
    @discardableResult public func pos_setImage(url: URL?, completionHandler:  (()->())? = nil) -> URLSessionDataTask? {
        guard let url = url else {
            self.dataTask = nil
            image = nil
            return nil
        }
        let dataTask = UIImageView.downloadSession.dataTask(
            with: url, completionHandler: { [weak self] (data, response, error) in
                guard let _ = self else { return }
                guard let data = data, let image = UIImage(data: data) else {
//                    log.error("Image download failed: \(String(describing: error))")
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.image = nil
                        completionHandler?()
                    }
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.image = image
                    completionHandler?()
                }
        })
        dataTask.resume()
        self.dataTask = dataTask
        return dataTask
    }
}
