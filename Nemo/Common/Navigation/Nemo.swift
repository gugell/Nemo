//
//  Nemo.swift
//  Aidwear
//
//  Created by Luis Burgos on 9/2/18.
//  Copyright © 2018 Shapp Inc. All rights reserved.
//

import UIKit

public final class NemoKeys: CustomStringConvertible {
    private let key: String
    
    public init(_ key: String) {
        self.key = key
    }
    
    public var description: String {
        return key
    }
}

/// Representes a ViewController inside an Storyboard which should be
/// mapped to a UI screen definition.
///
/// Also provides a custon init which adopts "ViewController" prefix nomenclature and
/// takes a single param that represents the name of the Storybaord
/// containing the controller with the following name structure:
///
/// Controller = "<NAME>" + "ViewController"
///
public struct Screen {
    let key: String
    let controllerName: String
    let storyboard: String
    
    public init(_ key: String, controller name: String, on storyboard: String) {
        self.key = key
        self.controllerName = name
        self.storyboard = storyboard
    }
    
    public init(named: NemoKeys) {
        self.init(named.description, controller: "\(named)ViewController", on: named.description)
    }
    
    func asController(embedInNavigation: Bool = false) -> UIViewController? {
        let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: self.controllerName)
        if embedInNavigation {
            return UINavigationController(rootViewController: controller)
        }
        return controller
    }
}

/// Define all aplication navigation that depends on storyboards
///
/// Provides "embedCases" array which are concrete controllers that
/// must be considered to be wrapped on a navigation controller.
open class Nemo {
    private static var embed: [Screen] = []
    private static var screens: [String : Screen] = [:]
    
    class func addEmbed(screen: Screen) {
        embed += [screen]
    }
    
    class func add(_ newScreens: Screen...) {
        for screen in newScreens {
            screens[screen.key] = screen
        }
    }
    
    class func go(to screenKey: NemoKeys) {
        let key = screenKey.description
        guard let screen = screens[key] else {
            fatalError("You should register a Screen with \(key) id using 'add(screen:)' method")
        }
        let controller = screen.asController(embedInNavigation: shouldEmbedInNavigation(for: key))
        Nemo.root(controller)
    }
}

extension Nemo {
    internal class func shouldEmbedInNavigation(for screenKey: String) -> Bool {
        let shouldEmbed = screens.contains { key, _ -> Bool in
            return key == screenKey
        }
        return shouldEmbed
    }
}

//MARK: - Root Helper
extension Nemo {
    class func root(_ controller: UIViewController?, animatesTransition: Bool = true){
        guard controller != nil else {
            fatalError("Controller MUST not be nil")
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.window == nil {
            print("Window on delegate is nil, creating new main screen with bounds")
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        appDelegate.window?.rootViewController = controller
        
        UIView.transition(
            with: appDelegate.window!,
            duration: animatesTransition ? 0.5 : 0.0,
            options: .transitionCrossDissolve,
            animations: {
                appDelegate.window?.makeKeyAndVisible()
        },
            completion: nil
        )
    }
}
