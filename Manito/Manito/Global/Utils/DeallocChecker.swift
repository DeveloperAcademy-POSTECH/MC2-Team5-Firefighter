//
//  DeallocChecker.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/09/16.
//

import UIKit

enum DeallocShowType {
    case alert
    case assert
    case log
}

extension UIViewController {
    func dch_checkDeallocation(showType: DeallocShowType = .alert, afterDelay delay: TimeInterval = 2.0) {
        let rootParentViewController = dch_rootParentViewController
        
        if isMovingFromParent || rootParentViewController.isBeingDismissed {
            let t = type(of: self)
            let disappearanceSource: String = isMovingFromParent ? "removed from its parent" : "dismissed"
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                let message = "\(t) not deallocated after being \(disappearanceSource)"
                
                switch showType {
                case .alert:
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                case .assert:
                    assert(self == nil, message)
                case .log:
                    NSLog("%@", message)
                }
            }
        }
    }
    
    private var dch_rootParentViewController: UIViewController {
        var root = self
        
        while let parent = root.parent {
            root = parent
        }
        
        return root
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
