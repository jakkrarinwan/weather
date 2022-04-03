//
//  KSmartStoryboard.swift
//  KUBOTA Smart Application
//
//  Created by WewillappTB on 9/8/2561 BE.
//  Copyright © 2561 Macbook. All rights reserved.
//

//swiftlint:disable all

import UIKit

enum MasterStoryboard: String {
    case main = "Main"
    case splashScreen = "SplashScreen"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type,
                                            function: String = #function,
                                            line: Int = #line,
                                            file: String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiate(storyboardName: MasterStoryboard) -> Self {
        return storyboardName.viewController(viewControllerClass: self)
    }
}
