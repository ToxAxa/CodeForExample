//
//  Storyboard+Extension.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import UIKit

extension UIStoryboard {
    
    static func loadViewController<V>(fromStoryboardNamed storyboardName: String = "\(V.self)") -> V {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.loadViewController()
    }
    
    func loadViewController<V>() -> V {
        guard let viewController = instantiateInitialViewController() as? V else {
            fatalError("Couldn't instantiate ViewController of \(V.self) type")
        }
        return viewController
    }
}


extension UIViewController {

    class func instantiate(from storyboard: UIStoryboard) -> Self {
        return instantiate(from: storyboard, indentifier: String(describing: self))
    }
    
    class func instantiate() -> Self {
        let className = String(describing: self)
        return instantiate(from: UIStoryboard(name: className, bundle: Bundle(for: self)), indentifier: className)
    }
    
    class func instantiate<T: UIViewController>(from storyboard: UIStoryboard, indentifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: indentifier) as! T
    }
}
