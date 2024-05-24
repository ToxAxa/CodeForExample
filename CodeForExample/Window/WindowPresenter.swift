//
//  WindowPresenter.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import Foundation

protocol WindowPresentationProtocol {
    func routeToView()
}

class WindowPresenter {
    
    private let router: WindowRoutingProtocol
    
    init(router: WindowRoutingProtocol) {
        self.router = router
        
        routeToView()
    }
}

extension WindowPresenter: WindowPresentationProtocol {
    func routeToView() {
        self.router.routeToView()
    }
}
