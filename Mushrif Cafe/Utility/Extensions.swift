//
//  Extensions.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/09/24.
//

import UIKit
import SafariServices
import SDWebImage
import SYBanner
import ProgressHUD

enum AppStoryboard: String {
    case main = "Main"
    case home = "Home"
    case profile = "Profile"
    case cart = "Cart"
}

protocol Instantiatable {
    static var storyboard: AppStoryboard { get }
    static func instantiate() -> Self
}

extension Instantiatable where Self: UIViewController {
    static func instantiate() -> Self {
        // swiftlint:disable force_cast
        UIStoryboard(storyboard).instantiateViewController(withIdentifier: String(describing: Self.self)) as! Self
    }
}

extension UIStoryboard {
    convenience init(_ storyboard: AppStoryboard) {
        self.init(name: storyboard.rawValue, bundle: nil)
    }
}

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { return false }
            
            return window.safeAreaInsets.top > 20
        }
    }
}

extension String {
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    var isValidEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    func localized() -> String {
        if let appLanguage = UserDefaultHelper.language {
            if appLanguage == "ar" {
                let path = Bundle.main.path(forResource: "ar", ofType: "lproj")
                let bundle = Bundle(path: path!)
                return NSLocalizedString(self, tableName: "Localizable", bundle: bundle!, value: self, comment: self)
            }
        }
        let path = Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: "Localizable", bundle: bundle!, value: self, comment: self)
    }
    
    func getAcronym() -> String {
        let array = components(separatedBy: .whitespaces)
        return String(array.reduce("") { $0 + String($1.first!)}.prefix(2))
    }
}

extension String {
    private static let formatter = NumberFormatter()
    
    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }
    
    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }
        
        Self.formatter.locale = locale
        
        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            let digit = Self.formatter.number(from: original)!
            let localized = Self.formatter.string(from: digit)!
            return (original, localized)
        }
        
        return maps.reduce(self) { converted, map in
            converted.replacingOccurrences(of: map.original, with: map.converted)
        }
    }
}

extension UITextField {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        let userLanguage = UserDefaultHelper.language
        if userLanguage == "ar" {
            if textAlignment == .natural {
                self.textAlignment = .right
            }
        }
    }
}

public extension UINavigationController {
    
    func pop(transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.popViewController(animated: false)
    }
    
    func push(viewController vc: UIViewController, transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.pushViewController(vc, animated: false)
    }
    
    private func addTransition(transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = type
        self.view.layer.add(transition, forKey: nil)
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
          let vc = viewControllers[viewControllers.count - viewsToPop - 1]
          popToViewController(vc, animated: animated)
        }
      }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    func toRoundedString(toPlaces places:Int) -> String {
        let amount = self.rounded(toPlaces: places)
        let str_mount = String(amount)
        
        let sub_amountStrings = str_mount.split(separator: ".")
        
        if sub_amountStrings.count == 1
        {
            var re_str = "\(sub_amountStrings[0])."
            for _ in 0..<places
            {
                re_str += "0"
            }
            return re_str
            
        }
        else if sub_amountStrings.count > 1, "\(sub_amountStrings[1])".count < places
        {
            var re_str = "\(sub_amountStrings[0]).\(sub_amountStrings[1])"
            let tem_places = (places -  "\(sub_amountStrings[1])".count)
            for _ in 0..<tem_places
            {
                re_str += "0"
            }
            return re_str
        }
        
        return str_mount
    }
}

class AlertView {

    static func show(title: String? = Bundle.applicationName, message: String?, preferredStyle: UIAlertController.Style = .alert, buttons: [String], completionHandler: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.view.tintColor = UIColor.primaryBrown
        for button in buttons {

            var style = UIAlertAction.Style.default
            let buttonText = button.lowercased().replacingOccurrences(of: " ", with: "")
            if buttonText == "cancel".localized() {
                style = .cancel
            }
            let action = UIAlertAction(title: button, style: style) { (_) in
                completionHandler(button)
            }
            alert.addAction(action)
        }

        DispatchQueue.main.async {
            if let app = UIApplication.shared.delegate as? AppDelegate, let rootViewController = app.window?.rootViewController {
                rootViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension Bundle {
    class var applicationName: String {

        if let displayName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return displayName
        } else if let name: String = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return name
        }
        return "No Name Found"
    }
}

extension UIViewController {
    
    func showWebView(_ urlString: String) {
        if let url = URL(string: urlString) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = false
            let vc = SFSafariViewController(url: url, configuration: config)
            self.present(vc, animated: true)
        }
    }

    func showBanner(message: String, status: LoadingStatus) {
        
        switch status {
        case .success:
            let styleBanner = SYDefaultBanner(message, direction: .top, style: .success)
            styleBanner.show(queuePosition: .front)
            styleBanner.messageFont = UIFont.poppinsLightFontWith(size: 14)
            styleBanner.messageColor = .white
            styleBanner.dismissOnSwipe = true
            styleBanner.autoDismiss = true
            styleBanner.show()
        case .error:
            let styleBanner = SYDefaultBanner(message, direction: .top, style: .warning)
            styleBanner.show(queuePosition: .front)
            styleBanner.messageFont = UIFont.poppinsLightFontWith(size: 14)
            styleBanner.messageColor = .white
            styleBanner.dismissOnSwipe = true
            styleBanner.autoDismiss = true
            styleBanner.show()
        case .warning:
            let styleBanner = SYDefaultBanner(message, direction: .top, style: .info)
            styleBanner.show(queuePosition: .front)
            styleBanner.messageFont = UIFont.poppinsLightFontWith(size: 14)
            styleBanner.dismissOnSwipe = true
            styleBanner.autoDismiss = true
            styleBanner.show()
        case .normal:
            let styleBanner = SYSimpleBanner(message, backgroundColor: .white, direction: .top)
            styleBanner.show(queuePosition: .front)
            styleBanner.messageFont = UIFont.poppinsLightFontWith(size: 14)
            styleBanner.messageColor = UIColor.primaryBrown
            styleBanner.dismissOnSwipe = true
            styleBanner.autoDismiss = true
            styleBanner.show()
        }
    }
}

//MARK: - DOWNLOAD IMAGE FROM URL OR STRING
extension UIImageView {
    
    //MARK: DOWNLOAD IMAGE FROM URL
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
        }.resume()
    }
    
    //MARK: DOWNLOAD IMAGE FROM LINK
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    func asyncronusImageWith(imageView: UIImageView, url:String?, _ placeHolderImage:UIImage){
        if let imageUrl = url {
            let imgUrl = URL.init(string: imageUrl)
            imageView.sd_setImage(with: imgUrl, placeholderImage: placeHolderImage, options: .highPriority, completed: nil)
        } else {
            imageView.image = placeHolderImage
        }
    }
    
    func loadURL(urlString : String?, placeholderImage : UIImage?)  {
        
        self.image = placeholderImage
        
        guard let lobjUrlString = urlString, !urlString!.isEmpty else {
            print("String is nil or empty.")
            return // or break, continue, throw
        }
        
        print("String From URL :>> \(lobjUrlString)")
        
        self.sd_setImage(with: URL(string: lobjUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") , placeholderImage: placeholderImage, options: [.refreshCached], completed: { (image, error, type, utlType)  in
            
            if image == nil {
                self.downloadImage(url : lobjUrlString, completition: { (image2) in
                    self.image = image2 == nil ? placeholderImage : image
                })
            } else {
                self.image = image
            }
        })
    }
    
    func downloadImage(url : String?, completition : @escaping (UIImage?) -> Void) {
        
        SDWebImageDownloader.shared.downloadImage(with: URL(string: url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") , options: [.ignoreCachedResponse] , progress: nil) { (image, data, error, isComplete) in
            if isComplete {
                completition(image)
            } else {
                completition(nil)
            }
        }
    }
}

extension UICollectionView {
    
    enum ErrorMessageType {
        case removeMessage
        case error(String)
    }
    func setEmptyMessage(_ message: String) {
            
            let emptyStateView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            
            // Create an image view
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.primaryBrown
            imageView.image = UIImage(systemName: "square.stack.3d.up.slash.fill")
            
            // Calculate the scaled size for the image
            let maxWidth = emptyStateView.bounds.width * 0.4 // Adjust the scaling as needed
            
            // Create a label
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            messageLabel.sizeToFit()
            
            // Set the frame for image view and label
            let totalHeight = 80 + messageLabel.frame.height + 16
            let verticalSpacing: CGFloat = 10.0
            
            let imageY = (emptyStateView.frame.height - totalHeight) / 2
            let labelY = imageY + 80 + verticalSpacing
            
            imageView.frame = CGRect(x: (emptyStateView.frame.width - 120) / 2,
                                     y: imageY, width: 120, height: 80)
            messageLabel.frame = CGRect(x: 0, y: labelY,
                                        width: emptyStateView.frame.width,
                                        height: messageLabel.frame.height)
            
            // Add image view and label to the empty state view
            emptyStateView.addSubview(imageView)
            emptyStateView.addSubview(messageLabel)
            
            // Set the empty state view as the background view
            self.backgroundView = emptyStateView
        }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UITableView {
    
    enum ErrorMessageType {
        case removeMessage
        case error(String)
    }
    func setEmptyMessage(_ message: String) {
        
        let emptyStateView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        // Create an image view
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.primaryBrown
        imageView.image = UIImage(systemName: "square.stack.3d.up.slash.fill")
        
        // Calculate the scaled size for the image
        let maxWidth = emptyStateView.bounds.width * 0.4 // Adjust the scaling as needed
        
        // Create a label
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.poppinsMediumFontWith(size: 16)
        messageLabel.sizeToFit()
        
        // Set the frame for image view and label
        let totalHeight = 80 + messageLabel.frame.height + 16
        let verticalSpacing: CGFloat = 10.0
        
        let imageY = (emptyStateView.frame.height - totalHeight) / 2
        let labelY = imageY + 80 + verticalSpacing
        
        imageView.frame = CGRect(x: (emptyStateView.frame.width - 120) / 2,
                                 y: imageY, width: 120, height: 80)
        messageLabel.frame = CGRect(x: 0, y: labelY,
                                    width: emptyStateView.frame.width,
                                    height: messageLabel.frame.height)
        
        // Add image view and label to the empty state view
        emptyStateView.addSubview(imageView)
        emptyStateView.addSubview(messageLabel)
        
        // Set the empty state view as the background view
        self.backgroundView = emptyStateView
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func scrollToTop(animated: Bool) {
        let indexPath = IndexPath(row: 0, section: 0)
        if self.hasRowAtIndexPath(indexPath: indexPath) {
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
