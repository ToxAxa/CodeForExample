//
//  WindowRouter.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import UIKit

protocol WindowRoutingProtocol {
    func routeToView()
}

class WindowRouter: WindowRoutingProtocol {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
}

extension WindowRouter {
    func routeToView() {
        let view = LandingBuilder.build()
        self.window.rootViewController = view
        self.window.makeKeyAndVisible()
    }
}
